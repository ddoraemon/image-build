#!/usr/bin/env bash

before_build() {
    echo "构建前操作..."
}

pre_build() {
    local arch="$1"
    cd ./${repo}
    echo "当前要执行${arch}的构建前操作"
    echo "下载jdk1.8-${arch}.tar.gz"
    wget "http://public:Public123@${RESOURCE_IP}:8824/jdk/jdk1.8-${arch}.tar.gz"
    tar xvf jdk1.8-${arch}.tar.gz
    echo "下载jdk21-${arch}.tar.gz"
    wget "http://public:Public123@${RESOURCE_IP}:8824/jdk/jdk21-${arch}.tar.gz"
    tar xvf jdk21-${arch}.tar.gz
    wget "http://public:Public123@${RESOURCE_IP}:8824/jdk/maven-3.19.2.tar.gz"
    tar xvf maven-3.19.2.tar.gz
    echo "下载cmake源码"
    wget "http://public:Public123@${RESOURCE_IP}:8824/toolchain/cmake-3.31.12.tar.gz"
    cd ..
}
