#!/bin/bash

before_build() {
    echo "构建前操作..."
}

pre_build() {
    local arch="$1"
    echo "当前要执行${arch}的构建前操作"
}
