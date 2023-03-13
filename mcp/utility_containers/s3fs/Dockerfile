FROM python:3.8-slim

WORKDIR /var/ops

RUN apt update && \
    apt curl install jq s3fs awscli -y

COPY run.sh .

ENTRYPOINT ["bash", "/var/ops/run.sh"]
