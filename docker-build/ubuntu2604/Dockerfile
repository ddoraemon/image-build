FROM ubuntu:26.04

ENV TZ=Asia/Shanghai

COPY install.sh /

RUN chmod +x /install.sh \
    && /install.sh \
    && apt update \
    && rm -rf /install.sh \
    && rm -rf /var/lib/apt/lists/*
