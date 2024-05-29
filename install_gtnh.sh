#!/bin/bash

wget -q -O /tmp/gtnh.zip "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_$1_Server_Java_17-21.zip"

unzip -q /tmp/gtnh.zip -d /srv/gtnh

rm /tmp/gtnh.zip

sed -i 's/eula=false/eula=true/g' /srv/gtnh/eula.txt
chmod 777 /srv/gtnh/startserver-java9.sh
