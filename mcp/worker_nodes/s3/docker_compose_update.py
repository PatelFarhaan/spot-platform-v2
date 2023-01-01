import os
import json
from ruamel.yaml import YAML

deployment_config = json.load(open("../../../deployment.json"))

volume_config = deployment_config.get("VOLUME_CONFIG")
if volume_config:
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.default_flow_style = False
    yaml.indent(sequence=3, offset=1)

    file_path = "../../../docker-compose.yml"
    out = "./docker_compose_new.yml"

    with open(file_path) as ymlfile:
        data = yaml.load(ymlfile)

    data["services"]["main_application"]["volumes"] = volume_config
    with open(out, "w+") as fw:
        yaml.dump(data, fw)
