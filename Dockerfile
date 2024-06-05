# Fetch GTNH Server & Extract
FROM alpine:latest as prepare

ARG GTNH_VERSION=2.6.1
ARG PORT=25565

WORKDIR /tmp

# Download Server
ADD https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_${GTNH_VERSION}_Server_Java_17-21.zip gtnh.zip

# Extract Server Files
RUN unzip gtnh.zip -d gtnh && rm gtnh.zip

# Reconfigure Server File
COPY --chmod=+x ["set_config.sh", "/tmp"]
RUN sh set_config.sh eula true gtnh/eula.txt
RUN sh set_config.sh server-port "${PORT}" gtnh/server.properties
RUN sed -i '/^\s*java/!d' gtnh/startserver-java9.sh

# Deploy Prepared Server
FROM ghcr.io/graalvm/jdk-community:21

# Copy Prepared Instance to /srv/gtnh
COPY --from=prepare ["/tmp/gtnh", "/data"]

WORKDIR /data
VOLUME ["/data"]

RUN echo 'test' > test.txt

# Expose Port
EXPOSE ${PORT}

# Run Start Script
ENTRYPOINT exec sh startserver-java9.sh

