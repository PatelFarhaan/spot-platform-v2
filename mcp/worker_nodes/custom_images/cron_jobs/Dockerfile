FROM python:3.10.6-slim-buster AS builder

ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

RUN python3 -m venv /venv
COPY requirements.txt .
RUN pip3 install -r requirements.txt

FROM python:3.10.6-alpine AS runtime-image

ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

COPY --from=builder /venv /venv
RUN apk update && apk upgrade
RUN apk add util-linux && apk update
RUN apk add cloud-utils-growpart e2fsprogs-extra

WORKDIR /app

COPY requirements.txt /app/requirements.txt
COPY storage_check /app/storage_check
COPY cronjob /app/cronjob

RUN chmod +x /app/cronjob

CMD ["crond", "-f", "-d", "8"]
