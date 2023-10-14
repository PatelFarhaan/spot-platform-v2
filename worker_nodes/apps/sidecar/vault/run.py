# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import json
import os
import sys

import hvac
import requests

current_dir = os.path.dirname(os.path.abspath(__file__))

sys.path.append(f"{current_dir}/..")
from util import Utilities


# <==================================================================================================>
#                                             VAULT CLASS
# <==================================================================================================>
class Vault(Utilities):
    def __init__(self):
        super().__init__()
        self.vault_token = None
        self.username = "app_role"
        self.password = "password"
        self.app_path = "/app_path"
        self.mount_point = {"mount_point": "kv"}
        self.application = os.environ["APPLICATION"]
        self.environment = os.environ["ENVIRONMENT"]
        self.vault_address = self.deployment_config["VAULT_ADDR"]
        self.path = f"{self.environment}/{self.application}"

        self.client = self.init_server()

    def retrieve_token(self):
        payload = dict()
        payload["data"] = json.dumps({"password": self.password})
        payload["url"] = f"{self.vault_address}/v1/auth/userpass/login/{self.username}"

        _response = requests.post(**payload).json()
        self.vault_token = _response["auth"]["client_token"]
        assert self.vault_token

    def init_server(self):
        self.retrieve_token()
        _client = hvac.Client(
            url=self.vault_address,
            token=self.vault_token
        )
        if not _client.is_authenticated():
            print("UNABLE TO CONNECT TO VAULT. PLEASE VALIDATE THE VAULT ADDRESS AND PASSWORD!!!")
            sys.exit(1)
        print("SUCCESSFULLY CONNECTED TO VAULT SERVER")
        return _client

    def write_to_secrets_file(self, secrets, is_secret=True):
        if is_secret:
            print("INJECTING SECRETS INTO CONTAINERS...")
            _path = f"{self.app_path}/app.secret"
        else:
            print("INJECTING ENV VARIABLES INTO CONTAINERS...")
            _path = f"{self.app_path}/app.env"

        with open(_path, "w+") as file:
            for k, v in secrets.items():
                _v = v.replace("'", '"')
                file.writelines(f"{k}='{_v}'\n")

    def list_secrets(self, is_secret=True) -> dict:
        if is_secret:
            print("STARTING PROCESS TO RETRIEVE SECRETS FROM VAULT...")
            _path = f"{self.path}/secrets"
        else:
            print("STARTING PROCESS TO RETRIEVE ENV VARIABLES FROM VAULT...")
            _path = f"{self.path}/env"

        _response = self.client.secrets.kv.v2.read_secret(path=_path, **self.mount_point)
        _secrets = _response["data"]["data"]
        return _secrets

    def run(self):
        secrets = self.list_secrets(is_secret=True)
        self.write_to_secrets_file(secrets, is_secret=True)
        env_vars = self.list_secrets(is_secret=False)
        self.write_to_secrets_file(env_vars, is_secret=False)
        print("ALL SECRETS AND ENV VARS ARE SECURELY INJECTED INTO THE CONTAINER!!!")


# <==================================================================================================>
#                                                MAIN
# <==================================================================================================>
if __name__ == '__main__':
    Vault().run()
