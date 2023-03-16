import os
import sys
import hvac
import json
import time
import requests
from aws import AWS
from os import environ


class UnsealVault(AWS):
    def __init__(self):
        super().__init__()
        self.keys = None
        self.root_token = None
        self.vault_addr = environ["VAULT_ADDR"]
        self.config_file = environ["VAULT_CONFIG_FILE"]

        self.kms_id = self.get_kms_id()
        self.client = self.get_vault_client()

    def run_user_ops(self):
        def enable_kv_engine():
            print("ENABLING KV SECRET ENGINE...")
            _kv_enabled = self.client.sys.enable_secrets_engine('kv', 'kv', options={'version': 2})
            assert _kv_enabled.ok is True

        def create_policies():
            print("CREATING ADMIN POLICY...")
            _admin_policy = """path "*" { capabilities = ["create", "read", "update", "delete", "list"] }"""
            _admin_policy_added = self.client.sys.create_or_update_policy("admin", policy=_admin_policy)
            assert _admin_policy_added.ok is True

            print("CREATING APP ROLE POLICY...")
            _app_policy = """path "*" { capabilities = ["read", "list"] }"""
            _app_policy_added = self.client.sys.create_or_update_policy("app_role", policy=_app_policy)
            assert _app_policy_added.ok is True

        def enable_userpass_auth():
            print("ENABLING USER AUTH...")
            _enable_auth = self.client.sys.enable_auth_method("userpass")
            assert _enable_auth.ok is True

        def creating_userpass_users():
            print("CREATING ADMIN USER FOR TEAMS...")
            _admin_user = self.client.auth.userpass.create_or_update_user(
                policies="admin",
                password="password",
                username="admin_user"
            )
            assert _admin_user.ok is True

            print("CREATING APP ROLE USER FOR TEAMS...")
            _app_user = self.client.auth.userpass.create_or_update_user(
                policies="app_role",
                password="password",
                username="app_role"
            )
            assert _app_user.ok is True

            print("CREATING SPOT ROLE USER FOR TEAMS...")
            _spot_user = self.client.auth.userpass.create_or_update_user(
                policies="admin",
                password="password",
                username="spot_role"
            )
            assert _spot_user.ok is True

        create_policies()
        enable_kv_engine()
        enable_userpass_auth()
        creating_userpass_users()

    def get_vault_client(self, current_count=1, token=None):
        print(f"CONNECTING TO VAULT SERVER: ATTEMPT -> {current_count}")
        if current_count > 20:
            print("THERE SEEMS SOME ISSUE WITH VAULT CONNECTIVITY. NEEDS TO BE CHECKED MANUALLY!!!")
            sys.exit(1)

        try:
            if token:
                _client = hvac.Client(url=self.vault_addr, token=token)
            else:
                _client = hvac.Client(url=self.vault_addr)
            _client.sys.is_initialized()
            print("CONNECTION TO VAULT SERVER IS SUCCESSFUL!!!")
            return _client
        except:
            time.sleep(5)
            return self.get_vault_client(current_count + 1)

    def enable_audit_logs(self):
        payload = dict()
        payload["headers"] = {"X-Vault-Token": self.root_token}
        payload["url"] = f"{self.vault_addr}/v1/sys/audit/file"
        payload["data"] = json.dumps(
            {
                "type": "file",
                "options": {
                    "file_path": "stdout"
                }
            }
        )
        _audit = requests.post(**payload)
        assert _audit.status_code == 204

    def get_kms_id(self):
        data = self.get_vault_config()
        return data["seal"]["awskms"]["kms_key_id"]

    def get_vault_config(self):
        return json.load(open(self.config_file))

    def update_vault_config(self, data):
        with open(self.config_file, "w") as f:
            json.dump(data, f, indent=2)
        self.restart_vault_container()

    def update_kms_config(self, add_kms=True):
        def add_kms_to_vault():
            if "seal" not in data:
                data["seal"] = {
                    "awskms": {
                        "kms_key_id": self.kms_id,
                    }
                }
                self.update_vault_config(data)

        def remove_kms_to_vault():
            if "seal" in data:
                data.pop("seal")
                self.update_vault_config(data)

        data = self.get_vault_config()
        if add_kms:
            add_kms_to_vault()
        else:
            remove_kms_to_vault()

    def initialize_vault(self):
        print("CHECKING IF VAULT IS INITIALIZED...")

        if self.client.sys.is_initialized():
            print("VAULT IS ALREADY INITIALIZED!!!")
            self.update_kms_config(add_kms=True)
        else:
            print("VAULT IS NOT INITIALIZED")
            print("INITIALIZING VAULT...")
            self.update_kms_config(add_kms=False)

            result = self.client.sys.initialize()
            print("VAULT IS INITIALIZED")
            self.put_vault_keys_to_s3(result)
            self.update_kms_config(add_kms=True)
            self.unseal_vault(data=result)

    def restart_vault_container(self):
        print("RESTARTING VAULT CONTAINER...")
        os.system("docker restart vault-server")
        time.sleep(10)
        self.client = self.get_vault_client()

    def unseal_vault(self, data):
        print("CHECKING IF VAULT IS UNSEALED...")

        if self.client.sys.is_sealed():
            print("VAULT IS SEALED")
            print("STARTED PROCESS FOR UNSEALING VAULT...")

            self.keys = data['keys']
            self.root_token = data['root_token']
            print(f"ROOT TOKEN: {self.root_token}")

            self.client.sys.submit_unseal_keys(self.keys, migrate=True)
            print("IS VAULT SEALED: ", self.client.sys.is_sealed())

            self.client = self.get_vault_client(token=self.root_token)
            self.enable_audit_logs()
            self.run_user_ops()
        else:
            print("VAULT IS UNSEALED!!!")
            print("TERMINATING VAULT-OPS CONTAINER.")

    def run(self):
        self.initialize_vault()


if __name__ == '__main__':
    UnsealVault().run()
