FROM centos
LABEL maintainer "J.W.Marsden <j.w.marsden@gmail.com>"

# This can be overridden by supplying new env vars to the docker run command
# like with `--envfile factorio.env` which would contain key/value pairs
ENV FACTORIO_VERSION 0.15.21
ENV WORLD_NAME level

RUN yum update -y -q && yum install -y -q wget
RUN wget -q -O factorio.tar.gz https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64 && tar -xf factorio.tar.gz && rm factorio.tar.gz
WORKDIR /factorio
RUN mkdir -p /factorio/saves
ADD start.sh /factorio/start.sh

# Exposes the volume so it can be linked externally
VOLUME ["/factorio/saves"]

# RUN cp /factorio/data/server-settings.example.json /factorio/data/server-settings.json
EXPOSE 34197/udp
EXPOSE 34198

# Encapsulate the logic for starting in a script
ENTRYPOINT ["/factorio/start.sh"]
