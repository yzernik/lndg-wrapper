FROM --platform=linux/arm64/v8 ubuntu:focal

RUN apt-get update -y \
    && apt-get upgrade -y\
    && apt-get install -y \
    python3-pip iproute2 wget curl tini \
    && pip3 install virtualenv bash \
    && apt install -y systemctl
RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq
COPY . src/

WORKDIR /src/squeaknode/

RUN virtualenv -p python3 .venv
RUN .venv/bin/pip install .

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD assets/utils/health-check.sh /usr/local/bin/health-check.sh
RUN chmod +x /usr/local/bin/health-check.sh

EXPOSE 8555
EXPOSE 18555
EXPOSE 18666
EXPOSE 18777
# Web server
EXPOSE 12994

EXPOSE 8889

# Make sure we use the virtualenv:
ENV PATH=".venv/bin:$PATH"

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
