import json

with open("/app_path/deployment.sh", "w") as file_write:
    export_vars = "export HOSTNAME=`hostname`\n"
    data = json.load(open("/app_path/deployment.json"))
    key_to_ignore = ["VOLUME_CONFIG"]

    for key, value in data.items():
        if key in key_to_ignore:
            continue

        if key == "CLIENT_APP_IMAGE":
            export_vars += f"export {key}=${{AWS_ECR_ID}}/${{AWS_ECR_REPO_NAME}}:{value}\n"
        else:
            export_vars += f"export {key}={value}\n"

    content = f"""#!/bin/bash

{export_vars}"""

    file_write.write(content)
