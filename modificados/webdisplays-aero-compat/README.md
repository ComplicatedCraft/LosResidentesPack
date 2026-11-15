# WebDisplays (fork con compatibilidad Aeronautics/Sable)

Pantallas con navegador web dentro del juego, que también funcionan dentro de naves de Create Aeronautics (subniveles de Sable).

## Origen

- Fork: [Agushh/webdisplays-aero-compat](https://github.com/Agushh/webdisplays-aero-compat), commit `8d1c3db` (v2.6.1). Licencia MIT.
- Ese fork sale del port a 1.21.1 de [brother-bill/webdisplays-mc](https://github.com/brother-bill/webdisplays-mc) (v2.6.0, commit `76f5c31`), que a su vez viene del WebDisplays oficial de CinemaMod.
- El WebDisplays oficial no tiene versión para NeoForge 1.21.1. La alternativa de Modrinth (WebDisplays REMASTER) usa MCEF, abandonado desde 2024, y no es compatible con Sable.

## Qué cambiamos (`cambios.patch`)

1. **Paquete `net/montoyo/wd/config` añadido.** El repo del fork no lo tiene (su `.gitignore` ignora `config/`) y no compila sin él. Se copia tal cual de brother-bill `76f5c31`, la base del fork.
2. **Rinku solo en el cliente.** Rinku (el Chromium que usa el fork) crashea en un servidor dedicado (`Attempted to load class .../Screen for invalid dist DEDICATED_SERVER`). La dependencia pasa a `side="CLIENT"` y `Rinku.scheduleForInit` se mueve de `SharedProxy.init()` a `ClientProxy.init()`.
3. **No crear navegadores antes de que Rinku arranque** (`ScreenData.createBrowser`). Rinku se inicializa unos segundos después de cargar (y en el primer arranque tiene que descargar Chromium). Si al entrar a un servidor había una pantalla cerca, el cliente se desconectaba con "Rinku was never initialized". Ahora el navegador queda a `null` y `ScreenRenderer` lo reintenta cada frame.
4. **Tecla de control del ratón en `V`** en vez de `R`, que ya usa Create Railways Navigator.

## Cómo llega al pack

- `mods/webdisplays.pw.toml` (`side = "both"`) apunta al jar subido a la Release `mod-webdisplays-2.6.1` de este repo.
- `mods/rinku.pw.toml` (Rinku 3.0.4, fijado) es `side = "client"`. Rinku descarga Chromium (unos 100 MB) en el primer arranque del cliente, a `<carpeta del juego>/rinku-libraries/`.

## Compilar

Necesita Java 21:

```sh
JAVA_HOME=/ruta/jdk-21 ./build.sh   # deja webdisplays-<versión>-losresidentes.jar en la carpeta actual
```

## Probado

- Servidor dedicado arranca con `Done (` y sin Rinku. Un bot de Carpet forma una pantalla 2x2 sin errores.
- Cliente entra al servidor con una pantalla cerca, sin desconexión, y la pantalla muestra la web con shaders (Complementary) activos.
- **Sin probar:** pantallas dentro de una nave de Aeronautics en marcha (es la parte del fork de Agushh), Windows y macOS.

## Al actualizar el fork

`git log 8d1c3db..<nuevo>` en el repo de Agushh. Si ya trae el paquete `config` o arregla el lado servidor, quita esa parte del parche. Rehaz `cambios.patch` con `git add -N -f src/main/java/net/montoyo/wd/config && git diff > cambios.patch`, cambia `COMMIT` en `build.sh` y repite las pruebas de arriba.
