FROM python:3.10.6-slim-buster AS builder

ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

RUN python3 -m venv /venv
COPY requirements.txt .
RUN pip3 install -r requirements.txt

FROM python:3.10.6-slim-buster AS runtime-image

ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY --from=builder /venv /venv

RUN apt update && apt -y upgrade
RUN apt install -y cloud-utils cron

WORKDIR /app

COPY storage_check /app/storage_check
COPY cronjob /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab
RUN crontab /etc/cron.d/crontab

ENTRYPOINT ["cron", "-f"]
