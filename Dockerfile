FROM ubuntu:focal

# set version label
LABEL maintainer="zoilomora"

# environment settings
ENV HOME="/root"
WORKDIR /tmp

# build environment
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" \
    apt install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt install -y \
        make \
        gcc \
        g++ \
        libssl-dev \
        git \
        libcurl4-gnutls-dev \
        libusb-dev \
        python3-dev \
        zlib1g-dev \
        libcereal-dev \
        liblua5.3-dev \
        uthash-dev \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output

# You need CMake version 3.16.0 or higher
RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz && \
    tar -xzvf cmake-3.20.1.tar.gz && \
    rm cmake-3.20.1.tar.gz && \
    cd cmake-3.20.1 && \
    ./bootstrap && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-3.20.1

# Boost Libraries
RUN wget https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.gz && \
    tar xfz boost_1_75_0.tar.gz && \
    rm boost_1_75_0.tar.gz && \
    cd boost_1_75_0/ && \
    ./bootstrap.sh && \
    ./b2 stage threading=multi link=static --with-thread --with-system && \
    ./b2 install threading=multi link=static --with-thread --with-system && \
    cd ../ && \
    rm -rf boost_1_75_0

COPY entrypoint.sh /root/entrypoint.sh

ENTRYPOINT /root/entrypoint.sh
