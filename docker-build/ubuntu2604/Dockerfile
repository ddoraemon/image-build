FROM registry.cn-hangzhou.aliyuncs.com/rotigue/ubuntu2604:tsinghua-source

COPY retry /usr/bin

RUN chmod +x /usr/bin/retry \
    && apt update \
    && apt install -y git procps telnet iproute2 iputils-ping dnsutils curl tcpdump wget unzip \
    && rm -rf /var/lib/apt/lists/*
