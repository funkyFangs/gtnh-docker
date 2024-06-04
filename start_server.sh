#!/bin/bash

MEMORY=6G
INIT_MEMORY=${1:-$MEMORY}
MAX_MEMORY=${2:-$MEMORY}

java "-Xms${INIT_MEMORY}" "-Xmx${MAX_MEMORY}" \
	-Dfml.readTimeout=180 -Dfile.encoding=UTF-8 \
	-Djava.system.class.loader=com.gtnewhorizons.retrofuturabootstrap.RfbSystemClassLoader -Djava.security.manager=allow \
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
