#!/bin/bash

before_build() {
    echo "构建前操作..."
}

pre_build() {
    local arch="$1"
    echo "当前要执行${arch}的构建前操作"
    cd ./${repo}
    echo "下载mihomo-linux-${arch}-v${tag}"
    wget -O freestyle "http://public:Public123@192.168.60.100:8824/clash/${arch}/mihomo-linux-${arch}-v${tag}"
    wget "http://public:Public123@192.168.60.100:8824/clash/zashboard/dist.zip"
    unzip dist.zip
    mv dist zashboard
    cd ..
}
