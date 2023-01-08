import json
from ruamel.yaml import YAML

deployment_config = json.load(open("./deployment.json"))

volume_config = deployment_config.get("VOLUME_CONFIG")
if volume_config:
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.default_flow_style = False
    yaml.indent(sequence=3, offset=1)

    source_file = "./docker-compose.yml"
    destination_file = "./docker-compose.yml"

    with open(source_file) as ymlfile:
        data = yaml.load(ymlfile)

    data["services"]["main_application"]["volumes"] = volume_config
    with open(destination_file, "w+") as fw:
        yaml.dump(data, fw)
