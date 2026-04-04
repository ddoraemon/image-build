############################
# builder
############################
FROM registry.cn-hangzhou.aliyuncs.com/rotigue/debian13:base AS builder

WORKDIR /Python-3.13
COPY Python-3.13/ /Python-3.13/

RUN apt update && apt install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        libffi-dev \
        libssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libncursesw5-dev \
        liblzma-dev \
        libgdbm-dev \
        libexpat1-dev \
        libdb5.3-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN ./configure \
        --prefix=/opt/python3/3.13 \
        --enable-optimizations \
        --with-lto \
        --enable-shared \
    && make -j$(nproc) \
    && make install

# strip 二进制，减小体积
RUN strip /opt/python3/3.13/bin/python3.13 \
    && strip /opt/python3/3.13/lib/libpython3.13.so.* \
    && rm -rf /opt/python3/3.13/lib/python3.13/test \
    && rm -rf /opt/python3/3.13/lib/python3.13/config-3.13-*-linux-gnu \
    && rm -rf /opt/python3/3.13/lib/python3.13/idlelib

############################
# runtime
############################
FROM registry.cn-hangzhou.aliyuncs.com/rotigue/debian13:base AS runtime

RUN apt update && apt install -y --no-install-recommends \
        ca-certificates \
        libssl3 \
        zlib1g \
        libffi8 \
        libbz2-1.0 \
        libreadline8 \
        libsqlite3-0 \
        libncursesw6 \
        libgdbm6 \
        libexpat1 \
        libdb5.3 \
        liblzma5 \
        libc6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/python3/3.13 /opt/python3/3.13

# 注册共享库
RUN echo "/opt/python3/3.13/lib" > /etc/ld.so.conf.d/python3.13.conf \
    && ldconfig

# 不改 PATH，用软链接暴露到 /usr/local/bin
RUN ln -sf /opt/python3/3.13/bin/python3.13 /usr/local/bin/python3.13 \
    && ln -sf python3.13 /usr/local/bin/python3 \
    && ln -sf python3.13 /usr/local/bin/python \
    && ln -sf /opt/python3/3.13/bin/pip3.13 /usr/local/bin/pip3.13 \
    && ln -sf pip3.13 /usr/local/bin/pip3 \
    && ln -sf pip3.13 /usr/local/bin/pip

CMD ["python3.13"]
