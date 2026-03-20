FROM registry.cn-hangzhou.aliyuncs.com/rotigue/python3:py313

ARG VERSION
ENV VERSION=${VERSION}

RUN apt update && apt install -y supervisor \
    && mkdir -p /app/freestyle/bin \
    && mkdir -p /app/freestyle/config \
    && mkdir -p /app/freestyle/logs \
    && mkdir -p /app/freestyle/ui \
    && mkdir -p /app/freestyle/ui/default \
    && mkdir -p /app/freestyle/ui/zashboard \
    && pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple requests pyyaml \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 cache purge \
    && rm -rf /tmp/pip-*


COPY freestyle.conf /etc/supervisor/conf.d/

COPY fresh.conf /etc/supervisor/conf.d/

COPY ./freestyle_config_update.py /app/freestyle/bin/freestyle_config_update.py

COPY zashboard/ /app/freestyle/ui/zashboard/

COPY ./freestyle /app/freestyle/bin/freestyle

RUN chmod +x /app/freestyle/bin/freestyle

VOLUME ["/app/freestyle/config", "/app/freestyle/logs"]

ENTRYPOINT ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]

EXPOSE 7890 8080