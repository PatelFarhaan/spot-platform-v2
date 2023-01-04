FROM ubuntu

WORKDIR /app

RUN apt update -y && apt upgrade -y && apt install python3-pip -y

RUN pip3 install hvac

COPY unseal_automation_script.py /app/unseal_automation_script.py
