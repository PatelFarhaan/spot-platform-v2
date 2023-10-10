import json
import os

from ruamel.yaml import YAML


class DockerCompose:
    def __init__(self):
        self.deployment_config_file = "/app_path/deployment.json"
        self.docker_compose_file = "/app_path/docker-compose.yml"
        self.deployment_config = json.load(open(self.deployment_config_file))

    def get_app_replicas(self):
        # if its a tcp application, we need to set the replicas to 1
        if os.environ.get("TCP_APPLICATION") == 'True':
            return 1

        try:
            desired_replicas = int(self.deployment_config.get("DESIRED_REPLICAS"))
            print("desired_replicas is: ", desired_replicas)
        except Exception as e:
            print(e)
            desired_replicas = float("inf")

        cpu_count = int(os.cpu_count())
        replicas = (cpu_count * 2)
        return min(replicas, desired_replicas)

    def get_nginx_port(self):
        existing_ports = ["9999:9999"]

        if os.environ.get("TCP_APPLICATION") == 'True':
            return existing_ports

        for route in self.deployment_config["ROUTING"]:
            existing_ports.append(f"{route['internal_port']}:{route['internal_port']}")
        return list(set(existing_ports))

    def get_app_image(self):
        if os.environ.get("PUBLIC_DOCKER_IMAGE") == 'True':
            return self.deployment_config["CLIENT_APP_IMAGE"]
        else:
            ecr_id = self.deployment_config["AWS_ECR_ID"]
            app_image = self.deployment_config["CLIENT_APP_IMAGE"]
            app_ecr_name = self.deployment_config["AWS_ECR_APPS_REPO_NAME"]
            return f"{ecr_id}/{app_ecr_name}:{app_image}"

    def update_docker_compose(self):
        replicas = self.get_app_replicas()
        nginx_ports = self.get_nginx_port()
        app_ecr_image = self.get_app_image()

        ecr_id = self.deployment_config["AWS_ECR_ID"]
        volume_config = self.deployment_config["VOLUME_CONFIG"]
        mcp_ecr_name = self.deployment_config["AWS_ECR_MCP_REPO_NAME"]

        cronjob_ecr_image = f"{ecr_id}/{mcp_ecr_name}:cronjobs"

        yaml = YAML()
        yaml.preserve_quotes = True
        yaml.default_flow_style = False
        yaml.indent(sequence=3, offset=1)

        with open(self.docker_compose_file) as ymlfile:
            data = yaml.load(ymlfile)

        # Patching Main Application
        if volume_config:
            data["services"]["main_application"]["volumes"] = volume_config

        if os.environ.get("TCP_APPLICATION") == 'True':
            data["services"]["main_application"].pop("expose")
            app_ports = [f"{route['external_port']}:{route['internal_port']}" for route in
                         self.deployment_config["ROUTING"]]
            data["services"]["main_application"]["ports"] = app_ports
        else:
            app_ports = [f"{route['internal_port']}" for route in self.deployment_config["ROUTING"]]
            data["services"]["main_application"]["expose"] = app_ports

        data["services"]["main_application"]["image"] = app_ecr_image
        data["services"]["main_application"]["deploy"]["replicas"] = replicas

        if self.deployment_config["COMMANDS"]:
            data["services"]["main_application"]["command"] = self.deployment_config["COMMANDS"]

        # Patching Cronjobs
        data["services"]["cronjobs"]["image"] = cronjob_ecr_image

        # Patching Nginx
        data["services"]["nginx"]["ports"] = nginx_ports

        with open(self.docker_compose_file, "w+") as fw:
            yaml.dump(data, fw)

    def run(self):
        self.update_docker_compose()


if __name__ == '__main__':
    DockerCompose().run()
