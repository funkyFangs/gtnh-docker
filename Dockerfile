ARG GTNH_VERSION=2.6.1
ARG PORT=25565

FROM ghcr.io/graalvm/jdk-community:21

RUN ["install_gtnh.sh", "$PORT"]
RUN ["ln", "-s", "/srv/gtnh", "/data"]
EXPOSE "${PORT}/tcp"

WORKDIR ["/data"]
ENTRYPOINT ["startserver-java9.sh"]
