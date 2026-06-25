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
    cd ..


#    if [[ "$arch" == "arm64" ]]; then
#        echo "👉 执行 arm64 的 pre_build"
#        # arm64 专用代码
#        do_something_for_arm64
#    elif [[ "$arch" == "amd64" ]]; then
#        echo "👉 执行 amd64 的 pre_build"
#        # amd64 专用代码
#        do_something_for_amd64
#    else
#        echo "❌ 不支持的架构: $arch"
#        return 1
#    fi

}
