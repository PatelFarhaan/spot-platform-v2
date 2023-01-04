import hvac
import json
import time
from aws import AWS
from os import environ


def get_vault_client():
    try:
        _client = hvac.Client(url=environ["VAULT_ADDRESS"])
        _client.sys.is_initialized()
        return _client
    except Exception as e:
        print(e)
        time.sleep(5)
        return get_vault_client()


def get_vault_config():
    return json.load(open(config_file))


def update_vault_config(data):
    with open(config_file, "w") as f:
        json.dump(data, f, indent=2)


def update_kms_config():
    data = get_vault_config()

    if "seal" not in data:
        data["seal"] = {
            "awskms": {
                "region": "us-east-1",
                "access_key": "AKIA3IYIXYRKI6DKV4OU",
                "kms_key_id": "a2701869-7b71-43b0-8e2d-832439856c56",
                "secret_key": "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"
            }
        }
        update_vault_config(data)


def initialize_vault():
    if client.sys.is_initialized():
        print("VAULT IS ALREADY INITIALIZED!!!")
    else:
        print("INITIALIZING VAULT...")
        result = client.sys.initialize()
        # send result to S3 Vault
        root_token = result['root_token']
        keys = result['keys']

        if client.sys.is_initialized():
            if client.sys.is_sealed():
                print("Unsealing Vault..") # needs to be done with aws kms
                unseal_response = client.sys.submit_unseal_keys(keys)
                print("IS SEALED: ", client.sys.is_sealed())
                print(root_token)
                print(unseal_response)


def unseal_vault():
    ...


if __name__ == '__main__':
    aws_obj = AWS()
    client = get_vault_client()
    config_file = environ["VAULT_CONFIG_FILE"]
    initialize_vault()
    unseal_vault()
    update_kms_config()

# Store the keys in a safe place
# update json to add kms
# enable kv
# create a user for teams
# create read only token for ec2 to retrieve secrets to inject into containers
# Restart vault
