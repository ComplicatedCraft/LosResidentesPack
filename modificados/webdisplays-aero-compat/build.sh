#!/bin/sh
# Compila el fork de WebDisplays de Agushh con nuestro parche. Necesita Java 21 en JAVA_HOME.
# Uso: JAVA_HOME=/ruta/jdk-21 ./build.sh   → deja el jar en la carpeta desde la que se lanza
set -e
OUT=$PWD
COMMIT=8d1c3db
RINKU_VERSION_ID=JOrwMXrE   # Rinku 3.0.4-1.21.1 en Modrinth (solo para compilar, no se empaqueta)
HERE=$(cd "$(dirname "$0")" && pwd)
W=$(mktemp -d)
git clone -q https://github.com/Agushh/webdisplays-aero-compat.git "$W/src"
cd "$W/src" && git checkout -q $COMMIT && git apply "$HERE/cambios.patch"
# El build espera libs/rinku-neoforge-<ver>-mod.jar: es el jar anidado de la release de Rinku
URL=$(curl -s -H 'User-Agent: x' https://api.modrinth.com/v2/version/$RINKU_VERSION_ID | python3 -c "import json,sys;print(json.load(sys.stdin)['files'][0]['url'])")
curl -fsSL -o "$W/rinku.jar" "$URL"
mkdir -p libs && unzip -p "$W/rinku.jar" 'META-INF/jarjar/de.keksuccino.rinku-neoforge-*-mod.jar' > libs/rinku-neoforge-3.0.4-1.21.1-mod.jar
sh ./gradlew --no-daemon -q build
V=$(sed -n "s/^mod_version=//p" gradle.properties)
# El -all lleva Sable Companion dentro (jarJar); el otro jar no sirve
cp build/libs/webdisplays-$V-all.jar "$OUT/webdisplays-$V-losresidentes.jar" && ls "$OUT/webdisplays-$V-losresidentes.jar"
