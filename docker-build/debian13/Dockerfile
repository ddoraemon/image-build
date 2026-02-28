FROM registry.cn-hangzhou.aliyuncs.com/rotigue/python3:py313

RUN mkdir -p /app/ddns/bin \
    && pip3 install -v -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple pymysql paramiko \
    && pip3 cache purge \
    && rm -rf /tmp/pip-*

COPY ddns.py /app/ddns/bin/

ENTRYPOINT ["python3", "/app/ddns/bin/ddns.py", "--use-env"]
