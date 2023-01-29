import os
import json
import platform
from ruamel.yaml import YAML


class DockerCompose:
    def __init__(self):
        self.docker_compose_file = "/app_path/docker-compose.yml"

    @staticmethod
    def get_app_replicas():
        cpu_count = int(os.cpu_count())
        replicas = (cpu_count * 2) + 1
        return replicas

    @staticmethod
    def get_deployment_metadata():
        deployment_config = json.load(open("/app_path/deployment.json"))
        return deployment_config

    def update_docker_compose(self):
        replicas = self.get_app_replicas()
        deployment_config = self.get_deployment_metadata()

        ecr_id = deployment_config["AWS_ECR_ID"]
        app_port = deployment_config["CLIENT_APP_PORT"]
        app_image = deployment_config["CLIENT_APP_IMAGE"]
        volume_config = deployment_config["VOLUME_CONFIG"]
        mcp_ecr_name = deployment_config["AWS_ECR_MCP_REPO_NAME"]
        app_ecr_name = deployment_config["AWS_ECR_APPS_REPO_NAME"]
        app_ecr_image = f"{ecr_id}/{app_ecr_name}:{app_image}"
        cronjob_ecr_image = f"{ecr_id}/{mcp_ecr_name}:cronjobs"
        promtail_ecr_image = f"{ecr_id}/{mcp_ecr_name}:promtail"

        yaml = YAML()
        yaml.preserve_quotes = True
        yaml.default_flow_style = False
        yaml.indent(sequence=3, offset=1)

        with open(self.docker_compose_file) as ymlfile:
            data = yaml.load(ymlfile)

        # Patching Main Application
        if volume_config:
            data["services"]["main_application"]["volumes"] = volume_config

        data["services"]["main_application"]["expose"] = [app_port]
        data["services"]["main_application"]["image"] = app_ecr_image
        data["services"]["main_application"]["deploy"]["replicas"] = replicas

        # Patching Cronjobs
        data["services"]["cronjobs"]["image"] = cronjob_ecr_image

        # Patching Promtail
        data["services"]["promtail"]["image"] = promtail_ecr_image

        with open(self.docker_compose_file, "w+") as fw:
            yaml.dump(data, fw)

    def run(self):
        self.update_docker_compose()


if __name__ == '__main__':
    DockerCompose().run()
