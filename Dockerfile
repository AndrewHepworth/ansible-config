FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    apt install -y sudo

FROM base AS prime
ARG TAGS
RUN addgroup --gid 1000 andrew 
RUN adduser --gecos andrew --uid 1000 --gid 1000 andrew
RUN echo "andrew:hello" | sudo chpasswd
#RUN adduser --gecos andrew --uid 1000 --gid 1000 --disabled-password andrew
RUN usermod -a -G sudo andrew
USER andrew
WORKDIR /home/andrew

FROM prime
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS init.yml"]
