FROM alpine

WORKDIR /app

COPY run.sh /app/run.sh

RUN apk add jq
RUN apk add curl
RUN apk add --no-cache aws-cli

CMD ["sh", "/app/run.sh"]
