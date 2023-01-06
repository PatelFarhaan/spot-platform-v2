FROM ubuntu

ENV DOCKERVERSION=20.10.21

RUN apt-get -y update &&  \
    apt upgrade -y && \
    apt install curl -y && \
    apt install python3-pip -y

RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz && \
    tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm docker-${DOCKERVERSION}.tgz

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /usr/src/app

RUN addgroup --system user && adduser --system --no-create-home --group user
RUN chown -R user:user /usr/src/app && chmod -R 755 /usr/src/app

COPY aws.py /usr/src/app/aws.py
COPY unseal_automation_script.py /usr/src/app/unseal_automation_script

USER user

COPY . /usr/src/app

ENTRYPOINT ["python3"]

CMD ["/usr/src/app/unseal_automation_script.py"]
