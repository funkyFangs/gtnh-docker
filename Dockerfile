# Fetch GTNH Server & Extract
FROM alpine:latest as prepare

ARG GTNH_VERSION=2.6.1
ARG PORT=25565
ARG INIT_MEMORY=6G
ARG MAX_MEMORY=6G

WORKDIR /tmp

ADD https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${GTNH_VERSION}_Server_Java_17-21.zip gtnh.zip
RUN unzip gtnh.zip -d gtnh && rm gtnh.zip

COPY ./set_config.sh .
RUN chmod +x set_config.sh
RUN sh set_config.sh 'eula' true gtnh/eula.txt
RUN sh set_config.sh 'server-port' "${PORT}" gtnh/server.properties

# Deploy Prepared Server
FROM ghcr.io/graalvm/jdk-community:21

VOLUME /data
WORKDIR /data
COPY --from=prepare /tmp/gtnh .
COPY ./start_server.sh .
RUN chmod +x start_server.sh

EXPOSE ${PORT}

ENTRYPOINT sh start_server.sh $INIT_MEMORY $MAX_MEMORY

