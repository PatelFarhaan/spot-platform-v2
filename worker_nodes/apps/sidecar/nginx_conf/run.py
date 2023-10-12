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
        self.routing = self.deployment_config["ROUTING"]
        self.rate_limit = self.deployment_config.get("RATE_LIMIT")
        self.rate_limit_enabled = self.deployment_config.get("RLE", False)

    @staticmethod
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

    def run(self):
        if self.tcp_application:
            print("TCP Application: Skipping nginx conf creation")
            exit(0)

        for index, route in enumerate(self.deployment_config["ROUTING"]):
            _conf = nginx.Conf()

            if self.rate_limit_enabled:
                _conf.add(nginx.Key("limit_req_zone", "$binary_remote_addr zone=limitbyaddr:100m rate=1r/s;"))
                _conf.add(nginx.Key("limit_req_status", 429))
            else:
                server_block = self.get_server_block(route, self.rate_limit_enabled)
                _conf.add(server_block)

            self.save_nginx(f'/app_path/nginx/conf.d/application_{index}.conf', _conf)


# <==================================================================================================>
#                                          MAIN
# <==================================================================================================>
if __name__ == '__main__':
    NginxConf().run()
