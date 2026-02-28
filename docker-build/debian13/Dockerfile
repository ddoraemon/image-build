FROM debian:trixie-slim

ENV TZ=Asia/Shanghai

RUN echo "Types: deb" > /etc/apt/sources.list.d/debian.sources \
    && echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/debian" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Suites: trixie trixie-updates trixie-backports" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Components: main contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" >> /etc/apt/sources.list.d/debian.sources \
    && echo "" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Types: deb" >> /etc/apt/sources.list.d/debian.sources \
    && echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/debian-security" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Suites: trixie-security" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Components: main contrib non-free non-free-firmware" >> /etc/apt/sources.list.d/debian.sources \
    && echo "Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" >> /etc/apt/sources.list.d/debian.sources \
    && apt update \
    && apt install procps -y \
    && rm -rf /var/lib/apt/lists/*
