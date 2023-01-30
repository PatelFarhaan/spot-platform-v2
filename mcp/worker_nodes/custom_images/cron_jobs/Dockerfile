FROM alpine

WORKDIR /app

RUN apk update && apk upgrade && apk add util-linux

RUN apk add --update --no-cache python3 && \
    ln -sf python3 /usr/bin/python && \
    python3 -m ensurepip

COPY requirements.txt /app/requirements.txt
COPY storage_check /app/storage_check
COPY cronjob /app/cronjob

RUN pip3 install -r requirements.txt && \
    rm -rf requirements.txt
RUN crontab ./cronjob

CMD ["/usr/sbin/crond", "-f"]
