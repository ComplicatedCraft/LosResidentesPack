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
https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
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
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
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
   java -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
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

## Teclas que conviene saber

| Tecla | Acción |
|---|---|
| `K` | Árbol de habilidades |
| `C` | Zoom (rueda para acercar más) |
| `O` | Elegir shaders |
| `F6` | Activar/desactivar shaders (se ha movido desde `K` para no chocar con las habilidades) |

---

# Servidor

El servidor necesita **Java 21** y unos **6 GB de RAM** solo para el juego. Los mods que son solo de cliente (shaders, zoom, etc.) no se instalan en el servidor.

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
java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
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

**`server.properties`:**

- `online-mode=false` permite jugar sin cuenta premium y que `/player` de Carpet funcione sin problemas. Ojo: en modo offline cualquiera puede entrar con cualquier nombre. Activa la lista blanca (`white-list=true` y `/whitelist add <nombre>`).
- `view-distance=10` y `simulation-distance=8` van bien. Distant Horizons se encarga de lo lejano.

**BlueMap:** la primera vez, abre `config/bluemap/core.conf`, pon `accept-download: true` y reinicia. El mapa queda en `http://<ip>:8100`.

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

**Equivalencias en NeoForge:**

- Dynmap → **BlueMap**
- InventoryRollbackPlus → **InvHistory**
- Continuity → **Continuity: NeoForged**

**Shaders con Create Aeronautics:** Iris Flywheel Compat, Iris Veil Compat y Aeronautics Hot Air Fix hacen que barcos, alas y globos se vean bien con shaders.

**Optimización:**

- Cliente y servidor: ModernFix, FerriteCore, Lithium, Clumps y spark.
- Cliente: Sodium, Sodium Extra, ImmediatelyFast, Entity Culling, More Culling, BadOptimizations y Dynamic FPS.
- Servidor: Noisium.
- Descartados a propósito: C2ME (en alfa, choca con Create, Sable y DH) y ServerCore (se pisa con Lithium).
