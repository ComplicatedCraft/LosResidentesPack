# Los Residentes Pack

NeoForge **21.1.266** · Minecraft **1.21.1** · un solo pack para Windows, Linux y macOS (cliente y servidor).

URL del pack:

```
https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
```

## Cliente (Prism Launcher, recomendado; también va en Mac Apple Silicon)

1. Crea una instancia: Minecraft 1.21.1 + NeoForge 21.1.266. Java 21.
2. Descarga [packwiz-installer-bootstrap.jar](https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest) en la carpeta `.minecraft` de la instancia.
3. Instancia → Editar → Ajustes → Personalizar comandos → *Comando de pre-lanzamiento*:
   ```
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
   ```
4. Dale 6-8 GB de RAM. Cada vez que abras el juego se actualiza solo.

En la primera instalación se preguntan los opcionales: **Distant Horizons**, **Complementary Reimagined/Unbound** y dos mods **SOLO MAC** (vienen desmarcados).

### Mac

- Marca **Slipstream** (más FPS en macOS) y **McMouser** (Ctrl+clic y Shift+rueda) en la ventana de opcionales. En Windows y Linux déjalos sin marcar.
- En Apple Silicon usa un Java 21 **arm64** (Prism lo descarga solo si eliges *Auto-detect / Download*). Con un Java x64 bajo Rosetta irá mucho peor.
- Con 8 GB de RAM unificada: dale 4-5 GB al juego, usa Reimagined o quita los shaders y desactiva Distant Horizons.
- Si ya instalaste y quieres cambiar los opcionales, borra `packwiz.json` de la carpeta de la instancia y vuelve a abrirla.

## Servidor

```sh
java -jar neoforge-21.1.266-installer.jar --install-server .
java -jar packwiz-installer-bootstrap.jar -g -s server https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
./run.sh nogui      # run.bat en Windows
```

Para actualizar: vuelve a ejecutar la línea de `packwiz-installer-bootstrap` antes de arrancar.

## Optimización incluida

- Ambos: ModernFix, FerriteCore, Lithium, Clumps, spark (`/spark profiler` para buscar lag).
- Cliente: Sodium, Sodium Extra, ImmediatelyFast, Entity Culling, More Culling, BadOptimizations, Dynamic FPS (baja los FPS con la ventana en segundo plano, ideal para portátiles).
- Servidor: Noisium (generación de terreno más rápida).
- Descartados a propósito: C2ME (sigue en alfa y choca con Create/Sable/DH) y ServerCore (se pisa con Lithium).

Flags recomendados para el servidor (`user_jvm_args.txt`):
```
-Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15
```

## Notas

- **WATERMeDIA está fijado en 2.1.36**: LittleFrames solo acepta la 2.1.x.
- **Distant Horizons está fijado en la versión 3.3.0**: de la 3.3.1 a la 3.3.3 el servidor crashea con Chunky al generar el mundo. Comprueba que esté arreglado antes de hacer `packwiz update distanthorizons`. Si DH os ofrece actualizarse dentro del juego, decid que no.
- Equivalencias en NeoForge: Dynmap → **BlueMap** (web en el puerto 8100; acepta la descarga en `config/bluemap/core.conf`), InventoryRollbackPlus → **InvHistory** (`/invhistory see <jugador>`), Continuity → **Continuity: NeoForged**.
- Árbol de habilidades: Pufferfish's Skills + Default Skill Trees (combate y minería, mejoras pequeñas). Se abre con la tecla `K`.
- `/player` (Carpet) funciona con `online-mode=false`.
- `options.txt` e `iris.properties` solo se escriben en la primera instalación (`preserve`), así que no te pisan la configuración.
