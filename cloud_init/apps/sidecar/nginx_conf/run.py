# <==================================================================================================>
#                                          IMPORTS
# <==================================================================================================>
import os
import sys

import nginx

current_dir = os.path.dirname(os.path.abspath(__file__))

sys.path.append(f"{current_dir}/..")
from util import Utilities


# <==================================================================================================>
#                                          NGINX CONF
# <==================================================================================================>
class NginxConf(Utilities):
    def __init__(self):
        super().__init__()

    @staticmethod
    def get_server_block_with_rl(_route):
        s = nginx.Server()
        internal_port = _route["servicePorts"]["internal"]
        rate_limit = _route.get("rateLimit", {})
        nodelay = rate_limit.get("nodelay")
        burst = rate_limit.get("burst", 0)

        _declarative = f"zone=limitbyaddr "
        if burst > 0:
            _declarative += f"burst={burst} "
        if nodelay:
            _declarative += f"nodelay"

        s.add(
            nginx.Key('listen', f'{internal_port}'),
            nginx.Key('server_name', '_'),
            nginx.Location(' /',
                           nginx.Key('send_timeout', 3600),
                           nginx.Key('proxy_send_timeout', 3600),
                           nginx.Key('proxy_read_timeout', 3600),
                           nginx.Key('proxy_connect_timeout', 3600),

                           nginx.Key('limit_req', _declarative),
                           nginx.Key('proxy_set_header', 'X-Forwarded-For $proxy_add_x_forwarded_for'),
                           nginx.Key('proxy_set_header', 'Host $host'),

                           nginx.Key('proxy_pass', f'http://main_application:{internal_port}')
                           )
        )
        return s

    @staticmethod
    def get_server_block(_route):
        s = nginx.Server()
        internal_port = _route["servicePorts"]["internal"]
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

    def run(self):
        if self.tcp_application:
            print("TCP Application: Skipping Creation of Nginx Conf")
            exit(0)

        for index, route in enumerate(self.routing):
            _conf = nginx.Conf()

            if route.get("rateLimit", {}).get("rate"):
                _rate = route["rateLimit"]["rate"]
                _rl_declarative = f"$binary_remote_addr zone=limitbyaddr:100m rate={_rate}"
                _conf.add(nginx.Key("limit_req_zone", _rl_declarative))
                _conf.add(nginx.Key("limit_req_status", 429))
                server_block = self.get_server_block_with_rl(route)
            else:
                server_block = self.get_server_block(route)

            _conf.add(server_block)
            self.save_nginx(f'/app_path/nginx/conf.d/application_{index}.conf', _conf)


# <==================================================================================================>
#                                          MAIN
# <==================================================================================================>
if __name__ == '__main__':
    NginxConf().run()
