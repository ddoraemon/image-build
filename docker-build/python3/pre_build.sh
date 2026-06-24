#!/usr/bin/env bash

before_build() {
    echo "构建前操作..."
}

pre_build() {
    local arch="$1"
    local num="${tag#py}"
    local python="Python-${num:0:1}.${num:1}"
    cd "./${repo}"
    echo "下载${python}.tar.gz"
    wget "https://public:Public123@dwebdav.rotigue.cn:9443/python3/${python}.tar.gz"
    cd ..
}
