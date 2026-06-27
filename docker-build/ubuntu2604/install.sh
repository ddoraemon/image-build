#!/bin/bash

get_arch=`arch`
echo $get_arch
if [[ $get_arch =~ "aarch64" || $get_arch =~ "armv7l" ]];then
    echo "Types: deb" > /etc/apt/sources.list.d/ubuntu.sources
    echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Suites: resolute resolute-updates resolute-backports" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Components: main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "" >> /etc/apt/sources.list.d/ubuntu.sources

    echo "Types: deb" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Suites: resolute-security" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Components: main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /etc/apt/sources.list.d/ubuntu.sources
else
    echo "Types: deb" > /etc/apt/sources.list.d/ubuntu.sources
    echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Suites: resolute resolute-updates resolute-backports" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Components: main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "" >> /etc/apt/sources.list.d/ubuntu.sources

    echo "Types: deb" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/ubuntu" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Suites: resolute-security" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Components: main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.sources
    echo "Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg" >> /etc/apt/sources.list.d/ubuntu.sources
fi
