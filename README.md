# Los Residentes Pack

Minecraft **1.21.1** · NeoForge **21.1.266** · Java **21**. Un solo pack para Windows, Linux y macOS, cliente y servidor.

Create + Create Aeronautics, árbol de habilidades, shaders (Complementary), Distant Horizons, BlueMap, Carpet y optimización.

## Descargas

Todo está en la [última Release](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest):

| Archivo | Para qué | ¿Se actualiza solo? |
|---|---|---|
| [`LosResidentes-Prism.zip`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Prism.zip) | Instancia para Prism Launcher (jugadores) | Sí, al abrir el juego |
| [`LosResidentes-Server.zip`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Server.zip) | Scripts del servidor (Windows, Linux, macOS y Docker) | Sí, al arrancar el servidor |
| [`LosResidentes.mrpack`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes.mrpack) | Modrinth App, ATLauncher y otros launchers | No, hay que bajar el nuevo |

Por debajo, todo sale de este repo con [packwiz](https://packwiz.infra.link/). La URL del pack es:

```
https://losresidentespack.pages.dev/pack.toml
```

---

# Jugadores

## Opción 1: Prism Launcher (recomendada)

Funciona igual en Windows, Linux y Mac (Intel y Apple Silicon). Es la única opción que se actualiza sola.

1. Instala [Prism Launcher](https://prismlauncher.org/) e inicia sesión con tu cuenta de Microsoft.
2. Descarga [`LosResidentes-Prism.zip`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Prism.zip).
3. En Prism: **Añadir instancia → Importar** y elige el zip (o arrastra el zip a la ventana de Prism).
4. Abre la instancia. La primera vez:
   - Prism descarga Java 21 y NeoForge solo.
   - Sale una ventana para elegir los **mods opcionales** (ver abajo). Dale a OK.
   - Se descargan todos los mods (tarda un poco).
5. Las siguientes veces, al abrir el juego se instalan solos los cambios del pack.

La instancia viene con 6 GB de RAM. Se cambia en *Editar → Ajustes → Java*.

## Opción 2: Prism o MultiMC configurado a mano

Por si no quieres usar el zip. También se actualiza sola.

1. Crea una instancia de Minecraft **1.21.1** con **NeoForge 21.1.266**.
2. Descarga [`packwiz-installer-bootstrap.jar`](https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest) y ponlo en la carpeta `minecraft` de la instancia (*Carpeta de la instancia → minecraft*).
3. *Editar → Ajustes → Comandos personalizados*, marca la casilla y pon en **Comando de pre-lanzamiento**:
   ```
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://losresidentespack.pages.dev/pack.toml
   ```

## Opción 3: Modrinth App, ATLauncher u otro launcher compatible con `.mrpack`

1. Descarga [`LosResidentes.mrpack`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes.mrpack).
2. Impórtalo en el launcher con su opción de importar un archivo o modpack (en Modrinth App, desde el botón de crear instancia).

Esta opción **no se actualiza sola**. Cuando salga una versión nueva, descarga el `.mrpack` otra vez. Para el resto de diferencias, mira la nota sobre los opcionales.

## Opción 4: Launcher oficial de Minecraft (o cualquier otro)

Es la opción más manual. Úsala solo si no puedes usar ninguna de las anteriores.

1. Instala NeoForge **21.1.266** con su [instalador](https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.266/neoforge-21.1.266-installer.jar) (*Install client*).
2. Mejor crea un perfil con su propia carpeta de juego, para no mezclar con tu `.minecraft` normal.
3. Pon [`packwiz-installer-bootstrap.jar`](https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest) en esa carpeta y ejecuta, desde ella:
   ```
   java -jar packwiz-installer-bootstrap.jar https://losresidentespack.pages.dev/pack.toml
   ```
4. Repite el paso 3 cada vez que se actualice el pack.

## Mods opcionales

La primera vez se pregunta por:

| Opcional | Por defecto | Cuándo desactivarlo / activarlo |
|---|---|---|
| Distant Horizons | ✅ | Desactívalo en equipos modestos o Macs con 8 GB |
| Complementary Reimagined | ✅ | Shaders recomendados (más ligeros) |
| Complementary Unbound | ❌ | Shaders más bonitos y más pesados |
| Slipstream | ❌ | **Solo Mac**: más FPS |
| McMouser | ❌ | **Solo Mac**: arregla Ctrl+clic y Shift+rueda |

- Para cambiarlos más tarde con packwiz (opciones 1, 2 y 4): borra `packwiz.json` de la carpeta del juego y vuelve a abrirlo, y la ventana saldrá otra vez.
- Con el `.mrpack` cada launcher los enseña a su manera: algunos los instalan todos y otros te preguntan. Activa o desactiva los mods desde la lista de mods del launcher.

## Si juegas en Mac

- Marca **Slipstream** y **McMouser** en los opcionales.
- En Apple Silicon (M1/M2/M3/M4) usa Java 21 **arm64**. Prism lo hace solo; con un Java x64 bajo Rosetta irá mucho peor.
- Con 8 GB de RAM: dale 4-5 GB al juego, usa Reimagined o quita los shaders, y desactiva Distant Horizons.

## Entrar al servidor (premium y no premium)

El servidor funciona en modo offline con **authlogic**, que protege los nombres:

- **Con cuenta premium:** entras directamente, como siempre.
- **Sin cuenta premium:** la primera vez que abras *Multijugador* te pide una contraseña (mínimo 8 caracteres). Ponla, dale a *Save* y ya está: a partir de ahí entras directamente, sin volver a escribirla. Nadie más puede entrar con tu nombre.
- La contraseña no se puede recuperar. Si la pierdes, o cambias de ordenador sin copiar la carpeta, pídele a un admin que te resetee (`/authlogic reset <nombre>`).
- La misma contraseña te vale para cualquier servidor con authlogic: no te la vuelve a pedir.
- Si al entrar sale **"Security Warning: Server Key Changed"**, el servidor se ha reinstalado. Pregunta a un admin si es así y, si lo es, borra el archivo `authlogic/client_servers.json` de tu instancia y vuelve a entrar (tu contraseña no se pierde, está en otro archivo).
- **No compartas la carpeta `authlogic/`** de tu instancia: es tu llave.

## Servidores detrás de Cloudflare Tunnel

El pack incluye **Modflared**: si el servidor está publicado con un Cloudflare Tunnel (por ejemplo `mc.tudominio.com`), basta con añadirlo como un servidor normal. No hay que instalar nada más.

## Teclas que conviene saber

| Tecla | Acción |
|---|---|
| `K` | Árbol de habilidades |
| `C` | Zoom (rueda para acercar más) |
| `O` | Elegir shaders |
| `F6` | Activar/desactivar shaders (se ha movido desde `K` para no chocar con las habilidades) |
| `V` | WebDisplays: usar el ratón en la pantalla que miras |

---

# Servidor

El servidor necesita **Java 21** y unos **6 GB de RAM** solo para el juego. Los mods que son solo de cliente (shaders, zoom, etc.) no se instalan en el servidor.

## Opción recomendada: Docker + panel web + SFTP + backups (Linux)

Pensada para dejar el servidor en un ordenador que no es tuyo (por ejemplo un Linux Mint con una cuenta que ya existe). Todo vive en contenedores dentro de `~/losresidentes`: no se instala Java ni nada más en el sistema, aparte de Docker, y se borra entero con una carpeta.

| Qué | Dónde | Para qué |
|---|---|---|
| **Crafty Controller** | `https://<ip>:8443` | Panel web: consola, arrancar y parar, editor de archivos, usuarios, tareas programadas y **backups** |
| **SFTP** | `sftp://<ip>:2222` | Subir y bajar archivos con FileZilla o WinSCP (es el "FTP" de toda la vida, pero cifrado). Solo ve los servidores, los backups y la carpeta de importar, no el resto del ordenador |
| **Tailscale** (opcional) | | Entrar al panel y al SFTP desde fuera de casa **sin abrirlos a internet** |

### 1. Instalar

Con la cuenta que ya hay en el ordenador (pedirá su contraseña de `sudo`):

```sh
curl -fsSL https://losresidentespack.pages.dev/server/panel/install.sh | bash
```

El script hace todo esto:

- Instala Docker desde los paquetes de Mint.
- Descarga el `docker-compose.yml`.
- Genera la contraseña del SFTP (se guarda en `~/losresidentes/.env`).
- Arranca los contenedores.
- Te enseña las direcciones y contraseñas.
- Pregunta si quieres instalar Tailscale.

Los contenedores arrancan solos cuando se enciende el ordenador.

### 2. Crear el servidor en el panel

1. Entra en `https://<ip>:8443`. El navegador avisará del certificado: es autofirmado, acéptalo. Inicia sesión con `admin` y la contraseña que mostró el instalador, y **cámbiala**.
2. **Create New Server → Minecraft Java → pestaña Import Server → Zip**. Elige `LosResidentes-Server.zip`, que el instalador ya dejó en la carpeta de importar (si no aparece, súbelo desde tu PC). En *Server JAR* pon `start.sh` y en el puerto `25565`. La RAM de ese formulario da igual.
3. En el servidor nuevo, ve a **Config** y cambia **Server Execution Command** a:
   ```
   sh start.sh
   ```
   Marca también **Auto Start** (que arranque con el ordenador) y **Crash Detection** (que se reinicie si se cae). Guarda.
4. Dale a **Start**. La primera vez descarga NeoForge y los mods (tarda) y se para pidiendo la EULA: en **Files** abre `eula.txt`, pon `eula=true` y arranca de nuevo.
5. En **Files**, ajusta `server.properties` (ver *Ajustes importantes*) y la RAM en `user_jvm_args.txt`.

A partir de aquí, **cada vez que el servidor arranca se actualizan solos los mods** desde GitHub.

### 3. Backups

En el servidor, pestaña **Backups**:

1. Pulsa el engranaje y pon en **Max Backups** cuántos guardar, por ejemplo `14`. Los más antiguos se borran solos.
2. Ve a **Schedules → Create New Schedule**: acción **Backup Server**, cada **1 día** a una hora tranquila, por ejemplo las 05:00.
3. Si quieres, añade otra tarea **Restart Server** diaria, unos minutos después del backup.

Los backups se guardan en `~/losresidentes/crafty/backups`. Se pueden bajar desde el panel o por SFTP (carpeta `backups`). Para restaurar uno, usa **Backups → Restore** en el panel.

> Un backup en el mismo disco no te protege si el disco muere. De vez en cuando bájate el último por SFTP, o activa la copia a Google Drive de abajo.

#### Copia a Google Drive (opcional)

Un contenedor `rclone` sube a Drive **solo el último backup**, como un único archivo `LosResidentes/ultimo-backup.zip` que se sustituye cada vez. Cada hora mira si Crafty ha hecho uno nuevo (ignora los que llevan menos de 5 minutos, por si siguen escribiéndose).

1. En **tu ordenador** (el servidor no tiene navegador), instala [rclone](https://rclone.org/install/) y ejecuta `rclone authorize "drive"`. Se abre el navegador, entras con la cuenta de Google y en la terminal sale un token `{"access_token":...}`. Cópialo.
2. En el servidor, crea `~/losresidentes/rclone/rclone.conf` con esto (pega tu token):

   ```ini
   [drive]
   type = drive
   scope = drive
   token = {"access_token":"..."}
   ```

3. Añade a `~/losresidentes/.env` la línea `COMPOSE_PROFILES=drive` (si ya usas el túnel: `COMPOSE_PROFILES=tunnel,drive`) y ejecuta `sudo docker compose up -d`.
4. Comprueba con `sudo docker logs rclone`: debe salir "Subiendo ..." y "Subido.". Si fallara, se reintenta a la hora siguiente.

- La carpeta de destino se cambia con `DRIVE_DEST=drive:OtraCarpeta` en el `.env`.
- Solo copia el último: en Drive no hay histórico. Si quieres más copias, deja también las de Crafty (Max Backups).
- El token de Google puede caducar si lo dejas mucho tiempo sin usar o si el proyecto de rclone queda en modo de pruebas. Si deja de subir, repite el paso 1 y 2. Para evitarlo, crea tu propio *client ID* en Google Cloud y añade `client_id` y `client_secret` al `rclone.conf`.

### 4. Acceso desde fuera

- **Jugadores:** en el router del dueño hay que redirigir **25565 TCP y UDP** a este ordenador. Si no tienes acceso al router, usa [playit.gg](https://playit.gg), que hace de túnel y admite TCP y UDP.
- **Panel y SFTP:** **no** los abras en el router. Instala Tailscale en ese ordenador (el instalador lo ofrece) y en el tuyo, con la misma cuenta. Así entras a `https://<ip-tailscale>:8443` y `sftp://<ip-tailscale>:2222` desde cualquier sitio, cifrado y sin exponer nada.
- **BlueMap:** el puerto 8100 sí puedes abrirlo si quieres que los jugadores vean el mapa web. Ábrelo junto con el **3876** (Create Track Map), que es de donde el mapa saca los trenes.
- **Alternativa sin abrir ningún puerto:** Cloudflare Tunnel (apartado siguiente).

### 5. Cloudflare Tunnel (opcional, sin abrir puertos)

Si tienes un dominio en Cloudflare, el túnel publica el panel, el juego y el mapa con nombres como `panel.tudominio.com` **sin tocar el router**. El contenedor `cloudflared` abre la conexión hacia Cloudflare desde dentro de la red.

**1. Crear el túnel.** En [Cloudflare Zero Trust](https://one.dash.cloudflare.com) ve a **Networks → Tunnels → Create a tunnel → Cloudflared**, ponle un nombre y copia el **token**: es la cadena larga que aparece en el comando de instalación, después de `--token`.

**2. Activarlo en el servidor.** El instalador pregunta por el token. Si ya instalaste, añádelo a `~/losresidentes/.env`:

```
CF_TUNNEL_TOKEN=<token>
COMPOSE_PROFILES=tunnel
```

y ejecuta `cd ~/losresidentes && sudo docker compose up -d`.

**3. Rutas.** En el túnel, pestaña **Public Hostname**, añade:

| Hostname | Service | Notas |
|---|---|---|
| `panel.tudominio.com` | `https://crafty:8443` | En *Additional settings → TLS* activa **No TLS Verify** (Crafty usa un certificado autofirmado) |
| `mc.tudominio.com` | `tcp://crafty:25565` | El juego |
| `mapa.tudominio.com` | `http://crafty:8100` | BlueMap (opcional) |
| `mapa.tudominio.com`, *Path* `api/.*` | `http://crafty:3876` | Trenes de Create en BlueMap. Esta ruta tiene que ir **encima** de la anterior en la lista |

**4. Proteger el panel (muy recomendable).** En **Access → Applications → Add an application → Self-hosted**, pon `panel.tudominio.com` y una política que solo deje entrar a tu email. Así, antes de llegar al login de Crafty, Cloudflare pide un código que te llega al correo.

**5. Avisar a Modflared.** En el DNS de tu dominio, crea un registro **TXT** con nombre `mc` y contenido `cloudflared-use-tunnel`.

**Guía detallada:** [docs/modflared.md](docs/modflared.md).

**Cómo entran los jugadores.** Cloudflare no deja conectar el juego a pelo por un túnel: el cliente necesita `cloudflared`. El pack ya incluye **[Modflared](https://modrinth.com/mod/modflared)**, que lo hace solo. Los jugadores añaden `mc.tudominio.com` como servidor y entran normal, sin instalar nada más.

**Limitaciones del túnel:**

- Solo pasa TCP. El UDP de Sable no va por el túnel, así que los barcos y aviones de Aeronautics se sincronizan por TCP, con algo más de latencia.
- Todo el tráfico pasa por Cloudflare, así que el ping puede ser algo mayor que con el puerto abierto.
- Si puedes abrir el 25565 en el router, para jugar es mejor. El túnel brilla para el panel y el mapa.
- Modflared avisa de que "no está probado del todo". Si diera problemas, los jugadores pueden entrar por la IP con el puerto abierto, por playit.gg o por Tailscale.
- El SFTP no pasa por el túnel: usa Tailscale para eso.

### Comandos útiles (en el ordenador del servidor)

```sh
cd ~/losresidentes
sudo docker compose ps               # ¿está todo arrancado?
sudo docker compose logs -f crafty   # ver el log del panel
sudo docker compose pull && sudo docker compose up -d   # actualizar Crafty y SFTP
sudo cat crafty/config/default-creds.txt                # contraseña inicial del panel
```

## Opción 1: script de arranque (Windows, Linux y macOS)

Es la manera más sencilla en un PC o un VPS.

1. Descarga [`LosResidentes-Server.zip`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Server.zip) y descomprímelo en una **carpeta vacía**.
2. Arranca:
   - **Windows:** doble clic en `start.bat`.
   - **Linux / macOS:** `sh start.sh`
3. La primera vez instala NeoForge y los mods, y se para pidiendo aceptar la EULA. Abre `eula.txt`, cambia `eula=false` por `eula=true` y vuelve a arrancar.
4. Configura `server.properties` (ver *Ajustes importantes*) y reinicia.

Cada vez que arrancas con el script, el servidor se actualiza solo: mods nuevos, y también NeoForge si cambia de versión. La RAM se cambia en `user_jvm_args.txt`; por defecto son 6 GB.

## Opción 2: Docker

Usa la imagen [`itzg/minecraft-server`](https://docker-minecraft-server.readthedocs.io/), que ya sabe instalar packs de packwiz.

1. Coge `docker-compose.yml` de [`LosResidentes-Server.zip`](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Server.zip) o de la carpeta [`server/`](server/docker-compose.yml) de este repo.
2. `docker compose up -d`

El mundo y la config quedan en `./data`. Cada `docker compose restart` actualiza los mods. Ya viene con la EULA aceptada y `online-mode=false`. Para mandar comandos a la consola: `docker compose exec minecraft rcon-cli`.

## Opción 3: hosting con panel (Pterodactyl y similares)

Depende de lo que te deje hacer tu hosting:

- **Si deja cambiar el comando de arranque o tiene consola SSH:** sube `start.sh` y usa `sh start.sh` como comando de arranque. Es la misma opción 1.
- **Si deja instalar modpacks de Modrinth:** sube o elige `LosResidentes.mrpack` (el panel se queda con la parte de servidor). No se actualiza solo.
- **Si solo deja subir archivos:** monta el servidor en tu PC con la opción 1, páralo y sube toda la carpeta por SFTP o FTP. Para actualizar, repite el proceso en tu PC y vuelve a subir la carpeta `mods`.

En cualquier caso, elige **NeoForge 21.1.266 para Minecraft 1.21.1** como tipo de servidor y Java 21.

## Opción 4: a mano

Esto es exactamente lo que hacen los scripts:

```sh
java -jar neoforge-21.1.266-installer.jar --install-server .
java -jar packwiz-installer-bootstrap.jar -g -s server https://losresidentespack.pages.dev/pack.toml
./run.sh nogui      # run.bat en Windows
```

El instalador de NeoForge está [aquí](https://maven.neoforged.net/releases/net/neoforged/neoforge/21.1.266/neoforge-21.1.266-installer.jar). Para actualizar, repite la segunda línea antes de arrancar.

## Ajustes importantes

**Puertos.** Ábrelos en el router o el firewall:

| Puerto | Protocolo | Para qué |
|---|---|---|
| 25565 | TCP | Minecraft |
| 25565 | UDP | Sable (movimiento fluido de barcos y aviones de Aeronautics; sin él va por TCP con más lag) |
| 8100 | TCP | BlueMap, el mapa web (opcional) |
| 3876 | TCP | Create Track Map: los trenes que se ven en BlueMap, y su propio mapa en `http://<ip>:3876` (opcional) |

**`server.properties`:**

- `online-mode=false` es obligatorio (`start.sh` y `start.bat` lo ponen solos). Con **authlogic** los premium se siguen verificando con Mojang y los no premium quedan atados a su contraseña, así que nadie puede suplantar a otro. Los bots de Carpet (`/player`) funcionan igual.
- **authlogic:** `/authlogic list` muestra los registrados, `/authlogic reset <nombre>` borra la llave de alguien que perdió su contraseña, y `/authlogic whitelist on|add|remove` es su lista blanca. Sus datos están en la carpeta `authlogic/` del servidor: entra en los backups y **no la compartas**. Si se pierde (por ejemplo al reinstalar el servidor sin ella), todos los no premium verán "Server Key Changed" y tendrán que borrar su `authlogic/client_servers.json`.
- `view-distance=10` y `simulation-distance=8` van bien. Distant Horizons se encarga de lo lejano.

**BlueMap:** la primera vez, abre `config/bluemap/core.conf`, pon `accept-download: true` y reinicia. El mapa queda en `http://<ip>:8100`, con las vías, trenes, estaciones y señales de Create en tiempo real (grupo *Trenes de Create* del menú de marcadores).

**Pregenerar el mundo (recomendado):** genera el terreno antes de que entre la gente, para que el servidor no vaya a tirones.

```
/chunky radius 3000
/chunky start
```

**Copias de inventario:** `/invhistory see <jugador>`.

**Medir el lag:** `/spark profiler start`, espera un rato y luego `/spark profiler stop`.

---

# Mantener el pack (administradores)

Hace falta [packwiz](https://packwiz.infra.link/installation/).

```sh
packwiz modrinth add <mod>        # añadir un mod
packwiz remove <mod>              # quitarlo
packwiz update --all              # actualizar todo (respeta los mods fijados)
packwiz refresh                   # tras tocar archivos a mano
git commit -am "..." && git push  # los jugadores lo reciben al abrir el juego
```

Para publicar los zips y el `.mrpack` nuevos: `git tag v1.0.2 && git push --tags`. La Action crea la Release sola.

---

# Notas técnicas

**Versiones fijadas (no actualizar sin probar):**

- **Distant Horizons 3.2.0**: la 3.3.0 desactiva los shaders de Iris sin avisar, y de la 3.3.1 a la 3.3.3 el servidor crashea con Chunky. Si DH ofrece actualizarse dentro del juego, decid que no.
- **WATERMeDIA 2.1.36**: LittleFrames solo acepta la 2.1.x.

**Configuración incluida:**

- **RRLS** solo oculta las recargas de recursos, no la carga inicial. Así no se puede entrar a un servidor antes de que los mods terminen de cargar, que daría un error de canales.
- `options.txt` e `iris.properties` solo se escriben en la primera instalación, así que no te pisan los ajustes. `rrls.toml` se fuerza siempre.
- `config/bluemap/webapp.conf` también se fuerza: es el que carga en BlueMap el script de los trenes de Create. Si lo cambias en el servidor, la siguiente actualización lo pisa; cámbialo en el repo.

**Equivalencias en NeoForge:**

- Dynmap → **BlueMap**
- dynmap-trains → port propio para BlueMap en [`modificados/dynmap-trains`](modificados/dynmap-trains)
- Create Track Map (sin versión para 1.21.1) → **Create Track Map: Unofficial Fork**
- WebDisplays (sin versión para 1.21.1) → fork con compatibilidad Aeronautics, retocado en [`modificados/webdisplays-aero-compat`](modificados/webdisplays-aero-compat)
- InventoryRollbackPlus → **InvHistory**
- Continuity → **Continuity: NeoForged**

**Shaders con Create Aeronautics:** Iris Flywheel Compat, Iris Veil Compat y Aeronautics Hot Air Fix hacen que barcos, alas y globos se vean bien con shaders.

**Conexión:** Modflared (cliente) para entrar a servidores detrás de Cloudflare Tunnel. authlogic (los dos lados) para el modo offline con premium automáticos y no premium con contraseña de una sola vez.

**Vanilla Backport** y **Tiny Takeover Backport** (los dos lados): traen contenido de versiones nuevas (mobs, bloques, crías rediseñadas, Golden Dandelion, etiquetas crafteables). Se configuran desde el menú de mods. Tiny Takeover necesita YACL también en el servidor, aunque Modrinth diga que es solo de cliente.

**WebDisplays** (los dos lados): pantallas con navegador web, también dentro de naves de Aeronautics. Usa **Rinku** (solo cliente), que descarga Chromium (unos 100 MB) la primera vez que abres el juego; hasta que termina, las pantallas salen apagadas.

**WorldEdit** (solo cliente): funciona en mundos de un jugador. En el servidor no está instalado, así que allí sus comandos no existen.

**Optimización:**

- Cliente y servidor: ModernFix, FerriteCore, Lithium, Clumps y spark.
- Cliente: Sodium, Sodium Extra, ImmediatelyFast, Entity Culling, More Culling, BadOptimizations y Dynamic FPS.
- Servidor: Noisium.
- Descartados a propósito: C2ME (en alfa, choca con Create, Sable y DH) y ServerCore (se pisa con Lithium).
