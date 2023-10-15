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
        self.app_config_file = "/app_path/config.yml"
        self.docker_compose_file = "/app_path/docker-compose.yml"
        self.cluster_config_file = "/app_path/cluster_config.json"
        self.platform_config_file = "/app_path/platform_config.yml"
        self.app_config = self.read_yaml_file(self.app_config_file)
        self.cluster_config = self.read_json_file(self.cluster_config_file)
        self.platform_config = self.read_yaml_file(self.platform_config_file)

        self.routing = self.app_config["routing"]
        self.deployment = self.app_config["deployment"]
        self.tcp_application = self.app_config.get("tcpApp", False)

    @staticmethod
    def read_json_file(file_path: str) -> json:
        values_data = json.load(open(file_path))
        return values_data

    @staticmethod
    def save_json(file_path: str, data: json):
        with open(file_path, "w+") as file:
            json.dump(data, file, indent=4)

    @staticmethod
    def read_yaml_file(file_path: str) -> json:
        yaml = YAML()
        yaml.preserve_quotes = True
        yaml.default_flow_style = False
        yaml.indent(sequence=3, offset=1)
        return yaml.load(open(file_path))

    @staticmethod
    def save_yaml(file_path: str, data: json):
        yaml = YAML()
        yaml.preserve_quotes = True
        yaml.default_flow_style = False
        yaml.indent(sequence=3, offset=1)
        with open(file_path, "w+") as fw:
            yaml.dump(data, fw)

    @staticmethod
    def save_nginx(file_path: str, data):
        nginx.dumpf(data, file_path)

    def get_app_replicas(self):
        if self.tcp_application:
            return 1

        try:
            print("Fetching desired_replicas...")
            desired_replicas = int(self.deployment["replicaPerHost"])
            print("desired_replicas is: ", desired_replicas)
        except Exception as e:
            print(e)
            desired_replicas = float("inf")

        cpu_count = int(os.cpu_count())
        replicas = (cpu_count * 2)

        if desired_replicas == -1:
            return replicas
        return min(replicas, desired_replicas)

    def get_nginx_port(self):
        existing_ports = ["9999:9999"]

        if self.tcp_application:
            return existing_ports

        for route in self.routing:
            internal_service_port = route["servicePorts"]["internal"]
            existing_ports.append(f"{internal_service_port}:{internal_service_port}")
        return list(set(existing_ports))

    def get_app_image(self):
        version = self.deployment.get("version")

        if self.deployment.get("imageRegistry") == "public":
            return version
        else:
            ecr_repo = self.cluster_config["mcp_ecr_id"]
            return f"{ecr_repo}:{version}"
