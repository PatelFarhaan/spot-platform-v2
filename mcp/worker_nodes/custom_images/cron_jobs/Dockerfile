FROM ubuntu

WORKDIR /app

RUN apt update
RUN apt upgrade -y
RUN apt install -y python3-pip
RUN apt install -y cron cloud-utils

COPY requirements.txt /app/requirements.txt
COPY storage_check /app/storage_check
COPY cronjob /app/cronjob

RUN pip3 install -r requirements.txt && rm -rf requirements.txt
RUN crontab ./cronjob

CMD ["/usr/sbin/crond", "-f"]
