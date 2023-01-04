import sys
import hvac
from os import environ
from functools import wraps


def check_if_service_exists(method):
    @wraps(method)
    def _impl(self, *method_args, **method_kwargs):
        if not self.service_exists():
            message = "Service does not exist"
            return self.send_response(result=False, message=message)
        return method(self, *method_args, **method_kwargs)

    return _impl


class Vault:
    def __init__(self):
        self.service = "backend"
        self.application = "webapp"
        self.vault_token = "hvs.bP81GSzK49k7TzqXxGZQ8QbC"
        # self.vault_token = environ["VAULT_TOKEN"]
        # self.vault_address = environ["VAULT_ADDR"]
        self.vault_address = "http://localhost:8200"
        self.path = f"{self.service}/{self.application}"

        self.client = self.init_server()

    @staticmethod
    def send_response(result: bool, message=None, data=None):
        return {
            "data": data,
            "result": result,
            "message": message
        }

    def init_server(self):
        _client = hvac.Client(
            url=self.vault_address,
            token=self.vault_token
        )
        if not _client.is_authenticated():
            print("UNABLE TO CONNECT TO VAULT. PLEASE VALIDATE THE VAULT ADDRESS AND PASSWORD!!!")
            sys.exit(1)
        return _client

    def service_exists(self):
        try:
            _response = self.client.secrets.kv.v2.list_secrets(self.service)
            if self.application in _response["data"]["keys"]:
                return True
        except Exception as e:
            print(e)
            return False

    def get_secret_obj(self) -> dict:
        _response = self.client.secrets.kv.v2.read_secret(path=self.path)
        return _response["data"]["data"]

    def write_secret(self, key, value):
        if not all([key, value]):
            message = "None of Key and Vault should be null"
            return self.send_response(result=False, message=message)

        if not self.service_exists():
            _secret = {key: value}
        else:
            _secret = self.get_secret_obj()
            _secret.update({key: value})

        _response = self.client.secrets.kv.v2.create_or_update_secret(
            secret=_secret,
            path=self.path
        )
        return self.send_response(result=True, data=_response)

    @check_if_service_exists
    def read_secret(self, key: str):
        _secret = self.get_secret_obj()
        if key in _secret:
            return self.send_response(result=True, data=_secret[key])

        message = "Secret does not exist"
        return self.send_response(result=False, message=message)

    @check_if_service_exists
    def delete_secret(self, key: str) -> dict:
        _secret = self.get_secret_obj()
        if key in _secret:
            _secret.pop(key)
            self.client.secrets.kv.v2.create_or_update_secret(
                secret=_secret,
                path=self.path
            )
            return self.send_response(result=True, message="Secret Deleted")

        message = "Secret does not exist"
        return self.send_response(result=False, message=message)

    @check_if_service_exists
    def list_secrets(self):
        _secret = self.get_secret_obj()
        return self.send_response(result=True, data=_secret)


if __name__ == '__main__':
    vault_obj = Vault()
    response = vault_obj.write_secret("farhaan", "world3")
    print("Write data response: ", response)

    # response = vault_obj.read_secret("hello2")
    # print("Read data response: ", response)
    #
    # response = vault_obj.delete_secret("ok")
    # print("Delete data response: ", response)
    #
    # response = vault_obj.list_secrets()
    # print("List Secrets response: ", response)
