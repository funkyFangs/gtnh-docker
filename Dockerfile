# Fetch GTNH Server & Extract
FROM alpine:latest as prepare

ARG GTNH_VERSION=2.6.1
ARG PORT=25565

WORKDIR /tmp

ADD https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${GTNH_VERSION}_Server_Java_17-21.zip gtnh.zip
RUN unzip gtnh.zip -d gtnh
RUN rm gtnh.zip
RUN sed -i 's/eula=false/eula=true/' gtnh/eula.txt

# Deploy Prepared Server
FROM ghcr.io/graalvm/jdk-community:21

COPY --from=prepare /tmp/gtnh /srv/gtnh
RUN ln -s /srv/gtnh /data

EXPOSE ${PORT}

VOLUME /data
WORKDIR /srv/gtnh

ENTRYPOINT startserver-java9.sh
