FROM alpine:latest as fetch

ARG GTNH_VERSION=2.6.1
ARG PORT=25565

WORKDIR /src

ADD https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${GTNH_VERSION}_Server_Java_17-21.zip gtnh.zip
RUN unzip gtnh.zip -d gtnh

FROM ghcr.io/graalvm/jdk-community:21

COPY --from=fetch /src/gtnh /srv/gtnh
RUN sed -i 's/eula=fase/eula=true/' /srv/gtnh/eula.txt
RUN ln -s /srv/gtnh /data

EXPOSE ${PORT}

VOLUME /data
WORKDIR /srv/gtnh

ENTRYPOINT startserver-java9.sh
