FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S sudo --noconfirm

RUN useradd -G wheel -m spider
RUN echo "spider ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chown -R spider:wheel /usr/local/src/

USER spider
CMD /bin/bash

WORKDIR /home/spider

COPY . /app
WORKDIR /app

RUN sh tests/devenv.sh
