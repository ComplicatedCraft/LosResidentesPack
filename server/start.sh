#!/usr/bin/env sh
# Servidor de Los Residentes (Linux y macOS). Ponlo en una carpeta vacía y ejecútalo:
#   sh start.sh
# Cada arranque instala/actualiza NeoForge y los mods desde GitHub y luego arranca el servidor.
set -e
cd "$(dirname "$0")"
PACK=https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml

# Versión de NeoForge que pide el pack
NEO=$(curl -fsSL "$PACK" | sed -n 's/^neoforge = "\(.*\)"/\1/p')
if [ ! -d "libraries/net/neoforged/neoforge/$NEO" ]; then
  echo ">> Instalando NeoForge $NEO..."
  curl -fsSL -o neoforge-installer.jar "https://maven.neoforged.net/releases/net/neoforged/neoforge/$NEO/neoforge-$NEO-installer.jar"
  java -jar neoforge-installer.jar --install-server .
  rm -f neoforge-installer.jar neoforge-installer.jar.log
fi

# RAM por defecto (cámbiala en user_jvm_args.txt)
grep -q '^-Xmx' user_jvm_args.txt 2>/dev/null || echo '-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200' >> user_jvm_args.txt

echo ">> Sincronizando mods..."
[ -f packwiz-installer-bootstrap.jar ] || curl -fsSL -o packwiz-installer-bootstrap.jar https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
java -jar packwiz-installer-bootstrap.jar -g -s server "$PACK"

exec sh ./run.sh nogui
