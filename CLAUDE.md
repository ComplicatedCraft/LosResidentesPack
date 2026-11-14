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
| `server/` | `start.sh`, `start.bat`, `docker-compose.yml` (itzg) y `panel/` (Crafty + SFTP + `install.sh`) |
| `tools/depcheck.py` | Comprueba las dependencias de una carpeta de mods instalada |
| `.github/workflows/release.yml` | Con un tag `v*`, publica la Release (zip de Prism, zip de servidor y `.mrpack`) |

`.packwizignore` excluye del pack todo lo que es solo del repo (README, CLAUDE.md, prism/, server/,
tools/, .github/). Si añades otra carpeta solo de repo, métela ahí.

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
- **Puertos**: 25565 TCP + **UDP** (Sable) y 8100 (BlueMap). Si un mod nuevo abre puertos, documéntalo en el README.
- Un "trozo de terreno flotante" puede ser terreno vanilla real. Compara con un servidor vanilla
  y el mismo seed antes de culpar a un mod de generación.

## Al terminar

Cuéntale al usuario qué mods se han añadido y por qué, cuál ha sido la alternativa si el que pedía
no existía para NeoForge, qué se ha probado y qué no (por ejemplo macOS o Windows), y si hace falta
crear un tag de Release.
