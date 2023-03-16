FROM ubuntu

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update --fix-missing && apt upgrade -y
RUN apt install jq curl gpg apt-transport-https ca-certificates curl software-properties-common awscli -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update && apt install docker-ce -y
RUN apt install docker-compose -y

RUN apt install python3-pip -y

WORKDIR /usr/src/app

RUN addgroup --system user && adduser --system --no-create-home --group user
RUN chown -R user:user /usr/src/app && chmod -R 755 /usr/src/app

COPY requirements.txt /usr/src/app/requirements.txt
RUN pip3 install -r requirements.txt && rm -rf requirements.txt

COPY run.sh /usr/src/app/run.sh
COPY apps /usr/src/app/apps

ENTRYPOINT ["bash"]

CMD ["run.sh"]
