#!/bin/bash

before_build() {
    echo "把ddns.py物料复制过来"
    cp ../ddns.py ./
}

pre_build() {
    local arch="$1"
    echo "当前要执行${arch}的构建前操作"
}
