# Los Residentes Pack: guía para mantener el pack

Modpack de **packwiz** para Minecraft **1.21.1 + NeoForge 21.1.266** (Java 21), publicado en
`github.com/ComplicatedCraft/LosResidentesPack`. Un solo pack sirve para cliente y servidor en
Windows, Linux y macOS. Los jugadores y el servidor se actualizan solos desde `main`, así que
**todo lo que se sube a `main` les llega en su siguiente arranque**. No subas nada sin probarlo.

Responde siempre en español.

## Estructura

| Ruta | Qué es |
|---|---|
| `pack.toml`, `index.toml` | Manifiesto de packwiz (se regenera con `packwiz refresh`) |
| `mods/`, `resourcepacks/`, `shaderpacks/` | Un `.pw.toml` por proyecto, más `Renfe Create.zip` (resourcepack propio) |
| `config/`, `options.txt` | Configuración por defecto que se envía a los clientes |
| `prism/` | Instancia de Prism (la Action la empaqueta en el zip) |
| `server/start.sh`, `start.bat` | Arranque universal del servidor: instala o actualiza NeoForge y los mods, y arranca |
| `server/docker-compose.yml` | Alternativa simple con la imagen `itzg/minecraft-server` (`PACKWIZ_URL`) |
| `server/panel/` | **Stack recomendado**: `docker-compose.yml` (Crafty + SFTP + cloudflared opcional) e `install.sh` para Linux Mint |
| `docs/modflared.md` | Guía de Cloudflare Tunnel y Modflared (admin y jugadores) |
| `tools/depcheck.py` | Comprueba las dependencias de una carpeta de mods instalada |
| `.github/workflows/release.yml` | Con un tag `v*`, publica la Release (zip de Prism, `LosResidentes-Server.zip` con `server/*` y `.mrpack`) |

`.packwizignore` excluye del pack todo lo que es solo del repo (README, CLAUDE.md, prism/, server/,
docs/, tools/, .github/). Si añades otra carpeta solo de repo, métela ahí.

## Servidor de producción

Va en un **Linux Mint que no es del usuario** y que ya tiene una cuenta. Hay que tocar el sistema lo mínimo:
todo vive en `~/losresidentes`, dentro de contenedores, y del sistema solo se instala Docker (`docker.io` y
`docker-compose-v2` de apt).

| Pieza | Detalle |
|---|---|
| **Crafty Controller** (`crafty`) | Panel web en 8443 (HTTPS autofirmado). El servidor se importa desde `LosResidentes-Server.zip` y su *Execution Command* es `sh start.sh`. Los backups y reinicios se programan en Crafty |
| **SFTP** (`atmoz/sftp`, puerto 2222) | Solo monta `crafty/servers`, `crafty/backups` (solo lectura) y `crafty/import`. **No** se da SSH a la cuenta del dueño. La contraseña está en `.env` (`SFTP_PASSWORD`) |
| **cloudflared** (perfil `tunnel`) | Solo arranca si `.env` tiene `COMPOSE_PROFILES=tunnel` y `CF_TUNNEL_TOKEN`. Túnel gestionado desde el panel de Zero Trust: `https://crafty:8443` (No TLS Verify y Cloudflare Access), `tcp://crafty:25565` y `http://crafty:8100` |
| **Tailscale** | Opcional, en el host. Es el acceso remoto para el panel y el SFTP. **Nunca** abrir 8443 ni 2222 en el router |

Detalles que importan si tocas `start.sh` o el stack:

- **Dentro de Crafty no hay `curl` ni `wget`.** `start.sh` descarga con `python3` si no hay `curl`. No le metas dependencias nuevas.
- **El `java` por defecto de Crafty es el 25.** `start.sh` busca Java 21 (`/usr/lib/jvm/java-21-openjdk*`) y lanza
  NeoForge directamente (`@user_jvm_args.txt @libraries/.../unix_args.txt`) en vez de con `run.sh`, que usaría el `java` del PATH.
- **La RAM se configura en `user_jvm_args.txt`**, no en el formulario de Crafty. Ese archivo de NeoForge no
  termina en salto de línea: añade siempre con `printf '\n...'`.
- **Si cambia la versión de NeoForge en `pack.toml`**, `start.sh` la reinstala solo. `docker-compose.yml` (itzg)
  lleva `NEOFORGE_VERSION` escrito a mano: actualízalo allí también.
- **Puertos:** 25565 TCP + **UDP** (Sable) y 8100 (BlueMap). El túnel de Cloudflare solo pasa TCP: con túnel,
  Sable usa TCP (más latencia en las naves).
- **Modflared** (cliente) es lo que permite a los jugadores entrar por el túnel. Necesita el TXT
  `cloudflared-use-tunnel` en el DNS del hostname del juego. Guarda sus datos en `<carpeta del juego>/modflared/`
  (`forced_tunnels.json` y el binario de `cloudflared`). Todo está en `docs/modflared.md`.
- Valida los cambios en compose e instalador con comprobaciones baratas: `bash -n install.sh`,
  `SFTP_PASSWORD=x docker compose config` y `COMPOSE_PROFILES=tunnel ... docker compose config --services`.

## Cuánto probar

- **Lo nuestro se prueba a fondo:** mods entre sí, configs del pack, `start.sh`, server + cliente entrando con capturas.
  Esas pruebas destaparon bugs reales (shaders apagados por DH, RRLS, dependencias que faltaban).
- **Las herramientas de terceros muy usadas no se prueban de punta a punta** (Crafty, itzg, cloudflared, Tailscale,
  launchers). El usuario lo pidió expresamente. Basta con leer su documentación y hacer comprobaciones concretas y
  rápidas (por ejemplo "¿la imagen trae curl?").

## Añadir un mod: proceso obligatorio

### 1. Comprobar que existe para NeoForge 1.21.1

```sh
curl -s -H 'User-Agent: x' "https://api.modrinth.com/v2/project/<slug>/version?loaders=%5B%22neoforge%22%5D&game_versions=%5B%221.21.1%22%5D" | python3 -c "import json,sys;[print(v['version_number'],v['id'],v['date_published'][:10]) for v in json.load(sys.stdin)[:5]]"
```

- Si solo existe para Fabric, **no uses Sinytra Connector**. Busca una alternativa nativa para NeoForge
  (así se hizo con Continuity → Continuity: NeoForged y con Dynmap → BlueMap) y avisa al usuario del cambio.
- Lee la descripción del mod para ver si es solo de cliente, solo de servidor o de los dos lados.
  Las etiquetas de Modrinth a veces mienten.

### 2. Añadirlo

```sh
packwiz modrinth add <slug>                               # última versión
packwiz modrinth add --project-id <id> --version-id <vid> # una versión concreta
packwiz pin <slug>                                        # si debe quedarse fijo
```

packwiz no conoce los entornos nuevos de Modrinth (`unknown`, `client_only_server_optional`…) y
en esos casos marca el mod como `both`. **Revisa el `side` de cada `.pw.toml` nuevo, también
el de sus dependencias**:

- `client`: render, shaders, HUD, zoom, input, resourcepacks, optimizaciones gráficas.
- `server`: mapas web, copias de seguridad, generación de terreno (Noisium), administración.
- `both`: todo lo que añade bloques, objetos, entidades o canales de red.

Para mods opcionales, añade al final del `.pw.toml`:

```toml
[option]
optional = true
default = false
description = "Texto que ve el jugador en el instalador."
```

Los mods de Mac van como opcionales con `default = false` y una descripción que empiece por "SOLO MAC".
packwiz no puede filtrar por sistema operativo.

### 3. Comprobar dependencias de verdad

Modrinth no siempre declara bien las dependencias. Así se colaron Rechiseled, que no traía sus
librerías, y WATERMeDIA 3.x, que LittleFrames no acepta.

```sh
packwiz serve --port 8089 &                                   # sirve el pack local
mkdir -p /tmp/lr-cli && cd /tmp/lr-cli && curl -fsSLO https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
java -jar packwiz-installer-bootstrap.jar -g -s client http://localhost:8089/pack.toml
python3 -I <repo>/tools/depcheck.py mods/*.jar
```

- `MISSING` = falta una dependencia obligatoria. Hay que añadirla.
- `VERSION?` = el rango de versión no cuadra. Revísalo a mano, porque hay falsos positivos:
  `needs minecraft [1.21,1.21.1)` y las versiones sin corchetes (que en Maven significan "esta o superior")
  funcionan bien en NeoForge.
- Haz lo mismo con `-s server` para la parte del servidor.
- Ojo: el instalador sin interfaz (`-g`) **instala todos los opcionales**. Es normal en las pruebas.

### 4. Probar el servidor

En una carpeta de pruebas, fuera del repo:

```sh
java -jar neoforge-21.1.266-installer.jar --install-server .
java -jar packwiz-installer-bootstrap.jar -g -s server http://localhost:8089/pack.toml
echo eula=true > eula.txt; printf 'online-mode=false\nserver-port=25599\n' > server.properties
./run.sh nogui
```

- Tiene que aparecer `Done (`. Si sale un crash, lee `crash-reports/`.
- Con un **mundo nuevo**, prueba también `chunky radius 150` + `chunky start`. El primer bug de
  Distant Horizons solo salía al generar terreno.
- Si el mod toca entidades, jugadores o red, prueba `player bot spawn` (Carpet).

### 5. Probar el cliente entrando al servidor

Lo de "carga sin errores" no basta. El bug de los shaders no daba ningún error en el log.

- Lanzador CLI: `portablemc` (con `pipx install portablemc`) en modo offline, dentro de `xvfb-run`
  para no abrir ventanas en el escritorio del usuario:
  ```sh
  xvfb-run -n 96 -s "-screen 0 1280x720x24" portablemc --main-dir <dir> start --mc-dir <cliente> \
    -u Tester --jvm-arg=-Xmx3G --resolution 1280x720 --join-server localhost --join-server-port 25599 neoforge::21.1.266
  ```
- Haz una captura (`DISPLAY=:96 XAUTHORITY=<xvfb-run>/Xauthority import -window root shot.png`) y **mírala**.
  Comprueba que se ven los shaders (nubes y sombras de Complementary) y los LODs de Distant Horizons a lo lejos.
- `xdotool` sirve para pulsar teclas en la ventana (F3, O para el menú de shaders).
- Si algo falla sin dar error, **busca el culpable por bisección**: aparta mitades de los mods solo
  de cliente, relanza y compara capturas.
- El render por software de la VM (llvmpipe) va a 2-3 FPS. Sirve para ver que funciona, no para medir rendimiento.

**Trampas de las pruebas:**

- Prism Launcher hereda `WAYLAND_DISPLAY` y abre ventanas en el escritorio real. Lánzalo con
  `env -u WAYLAND_DISPLAY QT_QPA_PLATFORM=xcb xvfb-run ...`.
- Nunca uses `pkill -f <patrón>` si el patrón aparece en tu propia línea de comandos, porque mata tu shell.
  Mata por PID.
- Una carpeta de cliente nueva enseña la pantalla de accesibilidad y no entra sola al servidor.
  El `options.txt` del pack lo evita con `onboardAccessibility:false` y `version:3955`.

### 6. Publicar

```sh
packwiz refresh
git add -A && git commit -m "..." && git push         # llega a todos en su siguiente arranque
git tag vX.Y.Z && git push origin vX.Y.Z               # regenera los zips y el .mrpack de la Release
```

Actualiza la lista de mods y las notas del `README.md` si cambia algo que vea el jugador o el admin.

## Reglas que ya nos han mordido

- **Distant Horizons fijado en 3.2.0**: la 3.3.0 desactiva los shaders de Iris sin avisar,
  y de la 3.3.1 a la 3.3.3 el servidor crashea con Chunky. No lo actualices sin repetir los pasos 4 y 5.
- **WATERMeDIA fijado en 2.1.36**: LittleFrames exige `[2.1,2.2)`. La 2.1.37 pide un plugin de la rama 3.x.
- **RRLS** con `hideOverlays = "RELOADING"`. Con `ALL`, el cliente puede conectarse antes de terminar
  de cargar y el servidor lo echa ("Incompatible client" o "channel missing").
- **Archivos `preserve`** (`options.txt`, `config/iris.properties`): solo se escriben si no existen.
  Para forzar un cambio de config en jugadores que ya lo tienen, el archivo **no** puede ser `preserve`
  y su **contenido tiene que cambiar**, porque packwiz-installer compara hashes.
- **Teclas**: antes de añadir un mod con teclas, mira si choca con alguna. Ya están ocupadas
  K (habilidades), R (Create Railways Navigator), C (zoom), O (shaders), F6 (activar/desactivar shaders)
  y Alt (Create, Copycats, Climbable Ropes).
- **Sable/Veil (Aeronautics) y shaders**: necesitan Iris Flywheel Compat, Iris Veil Compat y
  Aeronautics Hot Air Fix. No los quites.
- **Descartados**: C2ME (alfa, choca con Create, Sable y DH), ServerCore (se pisa con Lithium),
  Sinytra Connector (en general), Carry On (el usuario no lo quiere).
- **Puertos**: 25565 TCP + **UDP** (Sable) y 8100 (BlueMap). Si un mod nuevo abre puertos, documéntalo en el README
  y en `server/panel/docker-compose.yml`, y piensa si pasa por el túnel de Cloudflare (solo TCP y HTTP).
- **Modflared** debe seguir en el pack mientras se use el túnel. Si se cambia o actualiza, revisa `docs/modflared.md`.
- Un "trozo de terreno flotante" puede ser terreno vanilla real. Compara con un servidor vanilla
  y el mismo seed antes de culpar a un mod de generación.

## Al terminar

Cuéntale al usuario qué mods se han añadido y por qué, cuál ha sido la alternativa si el que pedía
no existía para NeoForge, qué se ha probado y qué no (por ejemplo macOS o Windows), y si hace falta
crear un tag de Release.
