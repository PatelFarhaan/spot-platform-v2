FROM alpine

WORKDIR /app

COPY run.sh /app/run.sh

RUN apk add --no-cache jq curl aws-cli
#RUN apk add curl
#RUN apk add --no-cache aws-cli

CMD ["sh", "/app/run.sh"]
