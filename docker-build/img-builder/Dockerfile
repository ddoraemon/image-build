FROM registry.cn-hangzhou.aliyuncs.com/rotigue/python3:py313

ARG VERSION
ENV VERSION=${VERSION}

RUN apt update \
  && apt install -y supervisor openssh-server iputils-ping dnsutils telnet wget jq \
  && apt install -y ca-certificates curl

RUN ssh-keyscan -p 50832 gitea.rotigue.cn > /root/.ssh/known_hosts \
    && ssh-keyscan gitee.com >> /root/.ssh/known_hosts \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
  && echo "Types: deb" > /etc/apt/sources.list.d/docker.sources \
  && echo "URIs: https://download.docker.com/linux/debian" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")" >> /etc/apt/sources.list.d/docker.sources \
  && echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources \
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
  && mkdir -p /opt/maven

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




ENTRYPOINT ["/usr/bin/supervisord","-n","-c","/etc/supervisor/supervisord.conf"]