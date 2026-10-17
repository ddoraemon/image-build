FROM registry.cn-hangzhou.aliyuncs.com/rotigue/python3:py313

ARG VERSION
ENV VERSION=${VERSION}

RUN apt update \
  && apt install -y supervisor openssh-server iputils-ping dnsutils telnet wget jq \
     build-essential \
     make \
     cmake \
     gcc-12 \
     g++-12 \
     gcc \
     g++ \
  && apt install -y ca-certificates curl

RUN ssh-keyscan -p 50832 gitea.rotigue.cn > /root/.ssh/known_hosts \
    && ssh-keyscan gitee.com >> /root/.ssh/known_hosts \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && chmod a+r /etc/apt/keyrings/docker.asc \
  && echo "Types: deb" > /etc/apt/sources.list.d/docker.sources \
  && echo "URIs: http://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Signed-By: /etc/apt/keyrings/docker.asc" >> /etc/apt/sources.list.d/docker.sources

RUN apt update \
  && apt install -y docker-ce-cli \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && mkdir -p /logs \
  && mkdir -p /root/.m2/repository \
  && mkdir -p /opt/java/jdk1.8 \
  && mkdir -p /opt/java/jdk21\
  && mkdir -p /opt/maven \
  && mkdir -p /opt/nodejs/node24

COPY retry /usr/bin/
RUN chmod +x /usr/bin/retry
COPY runner.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
COPY runner.pub /root/.ssh/id_rsa.pub
RUN chmod 644 /root/.ssh/id_rsa.pub
COPY runner /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
COPY sshd.conf /etc/supervisor/conf.d/
COPY dockerd.conf /etc/supervisor/conf.d/
COPY ./jdk1.8/ /opt/java/jdk1.8/
COPY ./jdk21/ /opt/java/jdk21/
COPY ./maven/ /opt/maven/
COPY ./settings.xml /root/.m2/
COPY ./node24/ /opt/nodejs/node24/

RUN ln -s /opt/java/jdk21/bin/java /usr/local/bin/java \
    && ln -sf /opt/java/jdk21/bin/java /usr/local/bin/java21 \
    && ln -sf /opt/java/jdk1.8/bin/java /usr/local/bin/java8 \
    && ln -sf /opt/maven/bin/mvn /usr/local/bin/mvn \
    && ln -sf /opt/python3/3.13/bin/python3.13 /usr/local/bin/python3.13 \
    && ln -sf /opt/python3/3.13/bin/pip3.13 /usr/local/bin/pip3.13 \
    && ln -sf /opt/nodejs/node24/bin/node /usr/local/bin/node \
    && ln -sf /opt/nodejs/node24/bin/npm /usr/local/bin/npm \
    && chmod +x /opt/java/jdk21/bin/java \
    && chmod +x /opt/java/jdk1.8/bin/java \
    && chmod +x /opt/maven/bin/mvn \
    && chmod +x /opt/python3/3.13/bin/python3.13 \
    && chmod +x /opt/python3/3.13/bin/pip3.13 \
    && chmod +x /opt/nodejs/node24/bin/node \
    && chmod +x /opt/nodejs/node24/bin/npm




ENTRYPOINT ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]