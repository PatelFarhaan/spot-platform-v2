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
        self.app_image = self.get_app_image()
        self.docker_compose = self.read_yaml_file(self.docker_compose_file)

    def update_nginx(self):
        self.docker_compose["services"]["nginx"]["ports"] = self.get_nginx_port()

    def update_logging(self):
        labels = self.docker_compose["x-logging"]["options"]["loki-external-labels"]
        labels = labels.replace("${APPLICATION}", os.environ["APPLICATION"])
        labels = labels.replace("${ENVIRONMENT}", os.environ["ENVIRONMENT"])
        self.docker_compose["x-logging"]["options"]["loki-external-labels"] = labels
        self.docker_compose["x-logging"]["options"]["loki-url"] = self.platform_config["LOKI_URL"]

    def update_app(self):
        self.docker_compose["services"]["main_application"]["image"] = self.app_image
        self.docker_compose["services"]["main_application"]["deploy"]["replicas"] = self.get_app_replicas()

        if self.deployment.get("extraConfig", {}).get("commands"):
            self.docker_compose["services"]["main_application"]["command"] = self.deployment["extraConfig"]["commands"]

        if self.tcp_application:
            self.docker_compose["services"]["main_application"].pop("expose")
            app_ports = [
                f"{route['servicePorts']['external']}:{route['servicePorts']['internal']}"
                for route in self.routing
            ]
            self.docker_compose["services"]["main_application"]["ports"] = app_ports
        else:
            app_ports = [
                f"{route['servicePorts']['internal']}"
                for route in self.routing
            ]
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
