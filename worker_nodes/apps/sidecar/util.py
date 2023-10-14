# <==================================================================================================>
#                                         IMPORTS
# <==================================================================================================>
import json
import os

import nginx
from ruamel.yaml import YAML


# <==================================================================================================>
#                                         UTILITIES CLASS
# <==================================================================================================>
class Utilities:
    def __init__(self):
        self.docker_compose_file = "/app_path/docker-compose.yml"
        self.deployment_config_file = "/app_path/deployment.json"
        self.deployment_config = self.read_json_file(self.deployment_config_file)
        self.tcp_application = self.deployment_config.get("TCP_APPLICATION", False)

        self.yaml = YAML()
        self.yaml.preserve_quotes = True
        self.yaml.default_flow_style = False
        self.yaml.indent(sequence=3, offset=1)

    @staticmethod
    def read_json_file(file_path: str) -> json:
        values_data = json.load(open(file_path))
        return values_data

    @staticmethod
    def save_json(file_path: str, data: json):
        with open(file_path, "w+") as file:
            json.dump(data, file, indent=4)

    def read_yaml_file(self, file_path=None) -> json:
        return self.yaml.load(open(file_path))

    def save_yaml(self, file_path: str, data: json):
        with open(file_path, "w+") as fw:
            self.yaml.dump(data, fw)

    @staticmethod
    def save_nginx(file_path: str, data):
        nginx.dumpf(data, file_path)

    def get_app_replicas(self):
        if self.tcp_application:
            return 1

        try:
            print("Fetching desired_replicas...")
            desired_replicas = int(self.deployment_config.get("DESIRED_REPLICA"))
            print("desired_replicas is: ", desired_replicas)
        except Exception as e:
            print(e)
            desired_replicas = float("inf")

        cpu_count = int(os.cpu_count())
        replicas = (cpu_count * 2)
        return min(replicas, desired_replicas)

    def get_nginx_port(self):
        existing_ports = ["9999:9999"]

        if self.tcp_application:
            return existing_ports

        for route in self.deployment_config["ROUTING"]:
            existing_ports.append(f"{route['internal_port']}:{route['internal_port']}")
        return list(set(existing_ports))

    def get_app_image(self):
        if self.deployment_config.get("PUBLIC_DOCKER_IMAGE"):
            return self.deployment_config["CLIENT_APP_IMAGE"]
        else:
            ecr_id = self.deployment_config["AWS_ECR_ID"]
            app_image = self.deployment_config["CLIENT_APP_IMAGE"]
            app_ecr_name = self.deployment_config["AWS_ECR_APPS_REPO_NAME"]
            return f"{ecr_id}/{app_ecr_name}:{app_image}"
