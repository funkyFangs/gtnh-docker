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
RUN sh set_config.sh 'eula' true gtnh/eula.txt
RUN sh set_config.sh 'server-port' "${PORT}" gtnh/server.properties

# Deploy Prepared Server
FROM ghcr.io/graalvm/jdk-community:21

VOLUME /data
WORKDIR /data
COPY --from=prepare /tmp/gtnh .

EXPOSE ${PORT}

ENTRYPOINT java \
	-Xms${INIT_MEMORY:-$MEMORY} \
	-Xm${MAX_MEMORY:-$MEMORY} \
	-Dfml.readTimeout=180 \
	-Dfile.encoding=UTF-8 \
	-Djava.system.class.loader=com.gtnewhorizons.retrofuturabootstrap.RfbSystemClassLoader \
	-Djava.security.manager=allow \
	--add-opens java.base/jdk.internal.loader=ALL-UNNAMED \
	--add-opens java.base/java.net=ALL-UNNAMED \
	--add-opens java.base/java.nio=ALL-UNNAMED \
	--add-opens java.base/java.io=ALL-UNNAMED \
	--add-opens java.base/java.lang=ALL-UNNAMED \
	--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
	--add-opens java.base/java.text=ALL-UNNAMED \
	--add-opens java.base/java.util=ALL-UNNAMED \
	--add-opens java.base/jdk.internal.reflect=ALL-UNNAMED \
	--add-opens java.base/sun.nio.ch=ALL-UNNAMED \
	--add-opens jdk.naming.dns/com.sun.jndi.dns=ALL-UNNAMED,java.naming \
	--add-opens java.desktop/sun.awt.image=ALL-UNNAMED \
	--add-opens java.desktop/com.sun.imageio.plugins.png=ALL-UNNAMED \
	--add-opens jdk.dynalink/jdk.dynalink.beans=ALL-UNNAMED \
	--add-opens java.sql.rowset/javax.sql.rowset.serial=ALL-UNNAMED-jar \
	-jar lwjgl3ify-forgePatches.jar \
	nogui

