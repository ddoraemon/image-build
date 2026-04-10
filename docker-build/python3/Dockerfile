############################
# builder
############################
FROM registry.cn-hangzhou.aliyuncs.com/rotigue/debian13:base AS builder

ARG VERSION
SHELL ["/bin/bash", "-c"]

WORKDIR /build

# 拷贝源码（确保外部只有一个 Python-x.x 目录）
COPY Python-* /build/

# 进入源码目录（自动匹配版本）
RUN PY_NUM=${VERSION#py} \
    && PY_VER="${PY_NUM:0:1}.${PY_NUM:1}" \
    && tar xvf Python-${PY_VER}.tar.gz \
    && mv Python-${PY_VER} Python-src

WORKDIR /build/Python-src

# 安装依赖
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
        uuid-dev \
        libzstd-dev \
        libnsl-dev \
    && rm -rf /var/lib/apt/lists/*

# 编译安装
RUN PY_NUM=${VERSION#py} && \
    PY_VER="${PY_NUM:0:1}.${PY_NUM:1}" && \
    ./configure \
        --prefix=/opt/python3/${PY_VER} \
        --enable-optimizations \
        --with-lto \
        --enable-shared \
        --with-ensurepip=install \
    && make -j$(nproc) \
    && make install

# 精简体积
RUN PY_NUM=${VERSION#py} && \
    PY_VER="${PY_NUM:0:1}.${PY_NUM:1}" && \
    strip /opt/python3/${PY_VER}/bin/python${PY_VER} && \
    strip /opt/python3/${PY_VER}/lib/libpython${PY_VER}.so.* && \
    rm -rf /opt/python3/${PY_VER}/lib/python${PY_VER}/test && \
    rm -rf /opt/python3/${PY_VER}/lib/python${PY_VER}/config-* && \
    rm -rf /opt/python3/${PY_VER}/lib/python${PY_VER}/idlelib && \
    find /opt/python3/${PY_VER} -name "*.a" -delete && \
    find /opt/python3/${PY_VER} -name "*.pyc" -delete && \
    find /opt/python3/${PY_VER} -name "__pycache__" -type d -exec rm -rf {} +

############################
# runtime
############################
FROM registry.cn-hangzhou.aliyuncs.com/rotigue/debian13:base AS runtime

ARG VERSION
SHELL ["/bin/bash", "-c"]

# 安装运行时依赖
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
        libuuid1 \
        libzstd1 \
        libnsl2 \
    && rm -rf /var/lib/apt/lists/*

# 拷贝 Python
COPY --from=builder /opt/python3 /opt/python3

# 注册动态库
RUN PY_NUM=${VERSION#py} && \
    PY_VER="${PY_NUM:0:1}.${PY_NUM:1}" && \
    echo "/opt/python3/${PY_VER}/lib" > /etc/ld.so.conf.d/python.conf && \
    ldconfig

# 创建软链接
RUN PY_NUM=${VERSION#py} && \
    PY_VER="${PY_NUM:0:1}.${PY_NUM:1}" && \
    ln -sf /opt/python3/${PY_VER}/bin/python${PY_VER} /usr/local/bin/python${PY_VER} && \
    ln -sf python${PY_VER} /usr/local/bin/python3 && \
    ln -sf python${PY_VER} /usr/local/bin/python && \
    ln -sf /opt/python3/${PY_VER}/bin/pip${PY_VER} /usr/local/bin/pip${PY_VER} && \
    ln -sf pip${PY_VER} /usr/local/bin/pip3 && \
    ln -sf pip${PY_VER} /usr/local/bin/pip

# 默认启动
CMD ["bash", "-c", "PY_NUM=${VERSION#py}; PY_VER=${PY_NUM:0:1}.${PY_NUM:1}; exec python${PY_VER}"]