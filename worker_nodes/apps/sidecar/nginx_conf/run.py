import os
import nginx


rate_limit = os.getenv("RATE_LIMIT")
rate_limit_enabled = True if os.getenv("RLE") is not None else False
main_application_port = int(os.getenv("CLIENT_APP_PORT"))


def get_server_block(rle=False):
    s = nginx.Server()

    if rle:
        s.add(
            nginx.Key('listen', '80'),
            nginx.Key('server_name', '_'),
            nginx.Location(' /',
                           nginx.Key('send_timeout', 3600),
                           nginx.Key('proxy_send_timeout', 3600),
                           nginx.Key('proxy_read_timeout', 3600),
                           nginx.Key('proxy_connect_timeout', 3600),

                           nginx.Key('limit_req', "zone=limitbyaddr nodelay"),
                           nginx.Key('proxy_set_header', "X-Forwarded-For $proxy_add_x_forwarded_for;"),
                           nginx.Key('proxy_set_header', "Host $host;"),

                           nginx.Key('proxy_pass', f'http://main_application:{main_application_port}')
                           )
        )
        return s
    else:
        s.add(
            nginx.Key('listen', '80'),
            nginx.Key('server_name', '_'),
            nginx.Location(' /',
                           nginx.Key('send_timeout', 3600),
                           nginx.Key('proxy_send_timeout', 3600),
                           nginx.Key('proxy_read_timeout', 3600),
                           nginx.Key('proxy_connect_timeout', 3600),

                           nginx.Key('proxy_set_header', "X-Forwarded-For $proxy_add_x_forwarded_for;"),
                           nginx.Key('proxy_set_header', "Host $host;"),

                           nginx.Key('proxy_pass', f'http://main_application:{main_application_port}')
                           )
        )
    return s


c = nginx.Conf()

if rate_limit_enabled:
    c.add(nginx.Key("limit_req_zone", "$binary_remote_addr zone=limitbyaddr:100m rate=1r/s;"))
    c.add(nginx.Key("limit_req_status", 429))
else:
    server_block = get_server_block(rate_limit_enabled)
    c.add(server_block)

nginx.dumpf(c, '/app_path/nginx/conf.d/application.conf')
