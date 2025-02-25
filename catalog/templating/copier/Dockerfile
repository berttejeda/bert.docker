FROM python:3.8.3-alpine3.12

ENV USER=copier
ENV USERPASSWORD=copier
ENV UID=5555
ENV GID=6666

RUN echo "===> Creating copier user ..."  &&\
adduser \
    --disabled-password \
    --gecos "" \
    --uid "$UID" \
    "$USER"

RUN echo "===> Add the main & community repos"  &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" > /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories &&\
    cat /etc/apk/repositories

RUN apk update && apk -U upgrade

RUN apk --update add coreutils util-linux ncurses

RUN echo "===> Installing required tools & dependencies" &&\
apk add --update --virtual build-dependencies python3-dev build-base
RUN apk --no-cache --update add bash git openssh-client

RUN echo "===> Installing pip ..."  &&\
python3 -m ensurepip &&\
pip3 install --trusted-host=pypi.org --trusted-host=github.com \
--trusted-host=files.pythonhosted.org --upgrade pip setuptools wheel 

RUN echo "===> Cleaning apk cache"  &&\
rm -rf /var/cache/apk/*

WORKDIR /setup

COPY requirements.* ./

RUN echo "===> Installing copier and Related Packages ..."  &&\
pip install --trusted-host=pypi.org --trusted-host=github.com \
--trusted-host=files.pythonhosted.org -r requirements.txt

# Uncomment the below when building for copier versions earlier than 6.0.0
# RUN pip3 install --trusted-host=pypi.org --trusted-host=github.com \
# --trusted-host=files.pythonhosted.org \
# --force-reinstall MarkupSafe==2.0.1

RUN ln -s $(which python3) /usr/bin/python

WORKDIR /

RUN echo "===> Cleaning up ..."
RUN rm -rf /setup &&\
rm -rf /var/cache/apk/*

RUN apk del build-dependencies python3-dev build-base

# fix /tmp permissions
RUN chmod u+rwx,g+rwx,o+x /tmp

USER $USER

WORKDIR /home/copier

ENTRYPOINT [ "/usr/local/bin/copier" ]