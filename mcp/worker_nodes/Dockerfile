FROM python:3.10.6-slim-buster AS builder

ENV LANG=C.UTF-8
ENV PYTHONUNBUFFERED=1
ENV PATH="/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1

RUN python3 -m venv /venv
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm -rf requirements.txt


FROM ubuntu AS runtime-image

ENV PATH="/venv/bin:$PATH"

COPY --from=builder /venv /venv

RUN apt update  && apt upgrade -y
RUN apt install jq curl gpg apt-transport-https ca-certificates curl software-properties-common -y

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/docker.gpg
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && apt update
RUN apt-cache policy docker-ce
RUN apt install docker-ce

RUN cd /tmp && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

WORKDIR /usr/src/app

RUN addgroup --system user && adduser --system --no-create-home --group user
RUN chown -R user:user /usr/src/app && chmod -R 755 /usr/src/app

COPY apps /usr/src/app/apps
COPY run.sh /usr/src/app/run.sh
COPY databases /usr/src/app/databases

#ENTRYPOINT ["bash"]

#CMD ["run.sh"]
