import sys
import hvac
import json
import requests
from os import environ


class Vault:
    def __init__(self):
        self.vault_token = None
        self.username = "app_role"
        self.password = "password"
        self.app_path = "/app_path"
        self.mount_point = {"mount_point": "kv"}
        self.application = environ["APPLICATION"]
        self.environment = environ["ENVIRONMENT"]
        self.vault_address = environ["VAULT_ADDR"]
        self.path = f"{self.application}/{self.environment}"

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

    def write_to_secrets_file(self, secrets):
        print("INJECTING SECRETS INTO CONTAINERS...")
        with open(f"{self.app_path}/app.secret", "w+") as file:
            for k, v in secrets.items():
                _v = v.replace("'", '"')
                file.writelines(f"{k}='{_v}'\n")

    def list_secrets(self) -> dict:
        _response = self.client.secrets.kv.v2.read_secret(path=self.path, **self.mount_point)
        _secrets = _response["data"]["data"]
        print("RETRIEVED SECRETS SUCCESSFULLY")
        return _secrets

    def run(self):
        print("STARTING PROCESS TO RETRIEVE SECRETS FROM VAULT...")
        secrets = self.list_secrets()
        self.write_to_secrets_file(secrets)
        print("ALL SECRETS ARE INJECTED SECURELY INTO THE CONTAINER!!!")


if __name__ == '__main__':
    Vault().run()
