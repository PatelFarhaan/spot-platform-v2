# <==================================================================================================>
#                                         IMPORTS
# <==================================================================================================>
import os
import sys

current_dir = os.path.dirname(os.path.abspath(__file__))

sys.path.append(f"{current_dir}/..")
from util import Utilities


# <==================================================================================================>
#                                          DOCKER COMPOSE
# <==================================================================================================>
class DockerCompose(Utilities):
    def __init__(self):
        super().__init__()
        self.app_ecr_image = self.get_app_image()
        self.ecr_id = self.deployment_config["AWS_ECR_ID"]
        self.volume_config = self.deployment_config["VOLUME_CONFIG"]
        self.mcp_ecr_name = self.deployment_config["AWS_ECR_MCP_REPO_NAME"]
        self.docker_compose = self.read_yaml_file(self.docker_compose_file)

    def update_nginx(self):
        self.docker_compose["services"]["nginx"]["ports"] = self.get_nginx_port()

    def update_logging(self):
        labels = self.docker_compose["x-logging"]["options"]["loki-external-labels"]
        labels = labels.replace("${APPLICATION}", os.environ["APPLICATION"])
        labels = labels.replace("${ENVIRONMENT}", os.environ["ENVIRONMENT"])
        labels = labels.replace("${HOSTNAME}", os.environ["INSTANCE_HOSTNAME"])
        self.docker_compose["x-logging"]["options"]["loki-external-labels"] = labels
        self.docker_compose["x-logging"]["options"]["loki-url"] = self.deployment_config["LOKI_URL"]

    def update_app(self):
        self.docker_compose["services"]["main_application"]["image"] = self.app_ecr_image
        self.docker_compose["services"]["main_application"]["deploy"]["replicas"] = self.get_app_replicas()

        if self.volume_config:
            self.docker_compose["services"]["main_application"]["volumes"] = self.volume_config

        if self.deployment_config["COMMANDS"]:
            self.docker_compose["services"]["main_application"]["command"] = self.deployment_config["COMMANDS"]

        if self.tcp_application:
            self.docker_compose["services"]["main_application"].pop("expose")
            app_ports = [f"{route['external_port']}:{route['internal_port']}" for route in
                         self.deployment_config["ROUTING"]]
            self.docker_compose["services"]["main_application"]["ports"] = app_ports
        else:
            app_ports = [f"{route['internal_port']}" for route in self.deployment_config["ROUTING"]]
            self.docker_compose["services"]["main_application"]["expose"] = app_ports

    def run(self):
        self.update_app()
        self.update_nginx()
        self.update_logging()
        self.save_yaml(self.docker_compose_file, self.docker_compose)


# <==================================================================================================>
#                                          MAIN
# <==================================================================================================>
if __name__ == '__main__':
    DockerCompose().run()
