# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.19

MAINTAINER Calaos Team <team@calaos.fr>

#Update ubuntu
RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# use bash instead of dash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure -f noninteractive dash

RUN apt-get install -y curl git htop unzip vim gawk wget git-core diffstat texinfo \
    gcc-multilib build-essential chrpath libssl-dev bc libncursesw5-dev zsh texinfo \
    libsdl1.2-dev xterm man cpio iputils-ping sudo

RUN apt-get clean && apt-get autoclean

# enable sshd
RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#create user
RUN useradd -ms /bin/zsh calaos
RUN echo "calaos:calaos" | chpasswd && adduser calaos sudo

#switch to calaos user
USER calaos
WORKDIR /home/calaos

#Install OMZSH
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN sed -i -E "s/^plugins=\((.*)\)$/plugins=(\1 git extract)/" ~/.zshrc

RUN git clone https://github.com/calaos/calaos-os

USER root
WORKDIR /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
