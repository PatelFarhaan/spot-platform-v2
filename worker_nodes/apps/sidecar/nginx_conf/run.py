import json
import os

import nginx


def get_data():
    res = {}
    data = json.load(open("/app_path/deployment.json"))

    res["routing"] = data["ROUTING"]
    res["rate_limit"] = os.getenv("RATE_LIMIT")
    res["rate_limit_enabled"] = True if os.getenv("RLE") is not None else False
    return res


def get_server_block(_route, rle=False):
    s = nginx.Server()
    internal_port = _route["internal_port"]

    if rle:
        s.add(
            nginx.Key('listen', f'{internal_port}'),
            nginx.Key('server_name', '_'),
            nginx.Location(' /',
                           nginx.Key('send_timeout', 3600),
                           nginx.Key('proxy_send_timeout', 3600),
                           nginx.Key('proxy_read_timeout', 3600),
                           nginx.Key('proxy_connect_timeout', 3600),

                           nginx.Key('limit_req', "zone=limitbyaddr nodelay"),
                           nginx.Key('proxy_set_header', 'X-Forwarded-For $proxy_add_x_forwarded_for'),
                           nginx.Key('proxy_set_header', 'Host $host'),

                           nginx.Key('proxy_pass', f'http://main_application:{internal_port}')
                           )
        )
        return s
    else:
        s.add(
            nginx.Key('listen', f'{internal_port}'),
            nginx.Key('server_name', '_'),
            nginx.Location(' /',
                           nginx.Key('send_timeout', 3600),
                           nginx.Key('proxy_send_timeout', 3600),
                           nginx.Key('proxy_read_timeout', 3600),
                           nginx.Key('proxy_connect_timeout', 3600),
                           nginx.Key('proxy_set_header', 'X-Forwarded-For $proxy_add_x_forwarded_for'),
                           nginx.Key('proxy_set_header', 'Host $host'),
                           nginx.Key('proxy_pass', f'http://main_application:{internal_port}')
                           )
        )
    return s


if __name__ == '__main__':
    # If TCP_APPLICATION is set, we dont need to create nginx conf
    if os.environ.get("TCP_APPLICATION") == 'True':
        print("TCP Application: Skipping nginx conf creation")
        exit(0)

    c = nginx.Conf()
    _data = get_data()

    for index, route in enumerate(_data["routing"]):
        if _data["rate_limit_enabled"]:
            c.add(nginx.Key("limit_req_zone", "$binary_remote_addr zone=limitbyaddr:100m rate=1r/s;"))
            c.add(nginx.Key("limit_req_status", 429))
        else:
            server_block = get_server_block(route, _data["rate_limit_enabled"])
            c.add(server_block)

        nginx.dumpf(c, f'/app_path/nginx/conf.d/application_{index}.conf')
