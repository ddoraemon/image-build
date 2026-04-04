#!/usr/bin/env bash

before_build() {
    echo "构建前操作..."
}

pre_build() {
    local arch="$1"
    cd ./${repo}
    wget "http://public:Public123@192.168.60.100:8824/python3/Python-3.13.12.tgz"
    tar xvf Python-3.13.12.tgz
    mv Python-3.13.12 Python-3.13
    cd ..
}
