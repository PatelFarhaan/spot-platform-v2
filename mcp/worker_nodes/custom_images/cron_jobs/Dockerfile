FROM alpine

WORKDIR /app

COPY . /app

RUN apk update && apk upgrade && apk add util-linux

RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip && \
    pip3 install -r requirements.txt

RUN crontab ./storage_check/disk_storage_check

CMD ["/usr/sbin/crond", "-f"]
