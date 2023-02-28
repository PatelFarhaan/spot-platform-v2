FROM docker:dind

RUN apk update && apk upgrade

RUN apk add git
