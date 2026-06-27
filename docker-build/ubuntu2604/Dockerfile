FROM registry.cn-hangzhou.aliyuncs.com/rotigue/ubuntu2604:tsinghua-source

RUN apt update \
    && apt install -y git procps telnet iproute2 iputils-ping dnsutils curl tcpdump wget unzip \
    && rm -rf /var/lib/apt/lists/*
