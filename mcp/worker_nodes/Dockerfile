FROM ubuntu

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update  && apt upgrade -y
RUN apt install jq curl gpg apt-transport-https ca-certificates curl software-properties-common awscli python3-pip -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/docker.gpg
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && apt update
RUN apt-cache policy docker-ce
RUN apt install docker-ce -y
RUN apt install docker-compose -y

WORKDIR /usr/src/app

RUN addgroup --system user && adduser --system --no-create-home --group user
RUN chown -R user:user /usr/src/app && chmod -R 755 /usr/src/app

COPY apps /usr/src/app/apps
COPY run.sh /usr/src/app/run.sh
COPY databases /usr/src/app/databases
COPY requirements.txt /usr/src/app/requirements.txt

RUN pip3 install -r requirements.txt
RUN rm -rf requirements.txt

#ENTRYPOINT ["bash"]

#CMD ["run.sh"]
