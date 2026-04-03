FROM registry.cn-hangzhou.aliyuncs.com/rotigue/debian13:tsinghua-source

ENV TZ=Asia/Shanghai

RUN apt update \
    && apt install -y git procps telnet iproute2 iputils-ping dnsutils curl tcpdump wget \
    && rm -rf /var/lib/apt/lists/*
