# Los Residentes Pack

NeoForge **21.1.266** · Minecraft **1.21.1** · un solo pack para Windows, Linux y macOS (cliente y servidor).

URL del pack:

```
https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
```

## Cliente con Prism Launcher (recomendado; también en Mac Apple Silicon)

1. Descarga **[LosResidentes-Prism.zip](https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Prism.zip)**.
2. En Prism: *Añadir instancia → Importar* y elige el zip (o arrástralo a la ventana de Prism).
3. Ábrela. La primera vez descarga Java 21, NeoForge y todos los mods; después se actualiza sola cada vez que la abres.

La instancia ya trae 6 GB de RAM; puedes cambiarlo en *Editar → Ajustes*.

<details><summary>Instalación manual (sin el zip)</summary>

1. Crea una instancia: Minecraft 1.21.1 + NeoForge 21.1.266.
2. Copia [packwiz-installer-bootstrap.jar](https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest) en la carpeta `minecraft` de la instancia.
3. *Editar → Ajustes → Comandos personalizados → Comando de pre-lanzamiento*:
   ```
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml
   ```
</details>

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

## Publicar una versión nueva

Tras subir cambios del pack, crea un tag (`git tag v1.0.1 && git push --tags`). La Action genera el zip de Prism y lo adjunta a la Release. Los jugadores no necesitan volver a descargarlo: la instancia se actualiza sola desde `main`.

## Notas

- **WATERMeDIA está fijado en 2.1.36**: LittleFrames solo acepta la 2.1.x.
- **Distant Horizons está fijado en 3.2.0**: la 3.3.0 desactiva los shaders de Iris sin avisar, y de la 3.3.1 a la 3.3.3 el servidor crashea con Chunky. Prueba ambas cosas antes de hacer `packwiz update distanthorizons`. Si DH os ofrece actualizarse dentro del juego, decid que no.
- **RRLS** está configurado (y forzado en cada actualización) para ocultar solo las recargas de recursos, no la carga inicial. Si se ocultara también la carga inicial, se podría entrar a un servidor antes de que los mods terminen de cargar y te echaría con un error de canales.
- Equivalencias en NeoForge: Dynmap → **BlueMap** (web en el puerto 8100; acepta la descarga en `config/bluemap/core.conf`), InventoryRollbackPlus → **InvHistory** (`/invhistory see <jugador>`), Continuity → **Continuity: NeoForged**.
- Árbol de habilidades: Pufferfish's Skills + Default Skill Trees (combate y minería, mejoras pequeñas). Se abre con la tecla `K`.
- Teclas cambiadas para evitar choques: activar/desactivar shaders es `F6` (no `K`); recargar shaders queda sin tecla (`R` es de Create Railways Navigator). Zoom: `C`.
- Shaders y Create Aeronautics: incluidos Iris Flywheel Compat, Iris Veil Compat y Aeronautics Hot Air Fix para que barcos, alas y globos se vean bien con shaders.
- `/player` (Carpet) funciona con `online-mode=false`.
- `options.txt` e `iris.properties` solo se escriben en la primera instalación (`preserve`), así que no te pisan la configuración.
