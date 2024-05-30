# Fetch GTNH Server & Extract
FROM alpine:latest as prepare

ARG GTNH_VERSION=2.6.1
ARG PORT=25565
ARG MEMORY=6G
ARG INIT_MEMORY
ARG MAX_MEMORY

WORKDIR /tmp

ADD https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${GTNH_VERSION}_Server_Java_17-21.zip gtnh.zip
RUN unzip gtnh.zip -d gtnh
RUN rm gtnh.zip

COPY ./set_config.sh set_config.sh
RUN /tmp/set_config.sh 'eula' true gtnh/eula.txt
RUN /tmp/set_config.sh 'server-port' "${PORT}" gtnh/server.properties

# Deploy Prepared Server
FROM ghcr.io/graalvm/jdk-community:21

COPY --from=prepare /tmp/gtnh /data

EXPOSE ${PORT}

VOLUME /data
WORKDIR /data

ENTRYPOINT java -Xms${INIT_MEMORY:-$MEMORY} -Xm${MAX_MEMORY:-$MEMORY} -Dfml.readTimeout=180 @java9args.txt -jar lwjgl3ify-forgePatches.jar nogui
