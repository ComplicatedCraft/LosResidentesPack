#!/usr/bin/env sh
# Servidor de Los Residentes (Linux, macOS y paneles como Crafty).
# Ponlo en una carpeta vacía y ejecútalo:   sh start.sh
# Cada arranque instala/actualiza NeoForge y los mods desde GitHub y luego arranca el servidor.
# Java: usa $JAVA si está definido; si no, busca un Java 21; si no, el `java` del sistema.
set -e
cd "$(dirname "$0")"
PACK=https://losresidentespack.pages.dev/pack.toml

# Descargar con curl, o con python3 si no hay curl (p. ej. dentro de Crafty)
fetch() {  # fetch <url> [archivo]
  if command -v curl >/dev/null 2>&1; then
    if [ -n "$2" ]; then curl -fsSL -o "$2" "$1"; else curl -fsSL "$1"; fi
  else
    python3 -c 'import sys,urllib.request as u; d=u.urlopen(sys.argv[1]).read(); (open(sys.argv[2],"wb").write(d) if len(sys.argv)>2 else sys.stdout.buffer.write(d))' "$@"
  fi
}

if [ -z "$JAVA" ]; then
  for j in /usr/lib/jvm/java-21-openjdk*/bin/java /usr/lib/jvm/temurin-21*/bin/java; do [ -x "$j" ] && JAVA="$j" && break; done
  [ -z "$JAVA" ] && [ -x /usr/libexec/java_home ] && JAVA="$(/usr/libexec/java_home -v 21 2>/dev/null)/bin/java"
  [ -x "$JAVA" ] || JAVA=java
fi

# Versión de NeoForge que pide el pack
NEO=$(fetch "$PACK" | sed -n 's/^neoforge = "\(.*\)"/\1/p')
[ -n "$NEO" ] || { echo "No se pudo leer $PACK"; exit 1; }
if [ ! -d "libraries/net/neoforged/neoforge/$NEO" ]; then
  echo ">> Instalando NeoForge $NEO..."
  fetch "https://maven.neoforged.net/releases/net/neoforged/neoforge/$NEO/neoforge-$NEO-installer.jar" neoforge-installer.jar
  "$JAVA" -jar neoforge-installer.jar --install-server .
  rm -f neoforge-installer.jar neoforge-installer.jar.log
fi

# RAM por defecto (cámbiala en user_jvm_args.txt)
grep -q '^[^#]*-Xmx' user_jvm_args.txt 2>/dev/null || printf '\n-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200\n' >> user_jvm_args.txt

echo ">> Sincronizando mods..."
[ -f packwiz-installer-bootstrap.jar ] || fetch https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar packwiz-installer-bootstrap.jar
"$JAVA" -jar packwiz-installer-bootstrap.jar -g -s server "$PACK"

echo ">> Arrancando con $("$JAVA" -version 2>&1 | head -1)"
exec "$JAVA" @user_jvm_args.txt "@libraries/net/neoforged/neoforge/$NEO/unix_args.txt" nogui "$@"
