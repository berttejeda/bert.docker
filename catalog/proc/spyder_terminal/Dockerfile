FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ jammy main restricted' >>/etc/apt/sources.list && \
    echo 'deb-src http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted' >>/etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y python3.9 python3.9-dev
COPY . .
RUN pip install -r requirements.txt

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]