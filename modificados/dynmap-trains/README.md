# dynmap-trains para BlueMap

| | |
|---|---|
| **Original** | [Zhincore/dynmap-trains](https://github.com/Zhincore/dynmap-trains), commit `00b19c7` |
| **Licencia** | GPL-3.0 (el original y este port). Copia en `LICENSE` |
| **Necesita** | Create Track Map (fork de AyOhEe, `create-track-map-unofficial-fork`) en el servidor y BlueMap |
| **Se carga desde** | `config/bluemap/webapp.conf` → `https://losresidentespack.pages.dev/modificados/dynmap-trains/ctm-trains.js` |

## Por qué

dynmap-trains es un script web para **Dynmap** (Leaflet). En NeoForge usamos **BlueMap** (three.js),
así que se reescribió en `ctm-trains.js`, un solo archivo JS sin compilación.

## Qué cambia respecto al original

- Dibuja con marcadores de BlueMap en lugar de capas de Leaflet: vías (blanco libre, rosa reservada,
  rojo ocupada), vagones (cian, el de cabeza en lila), nombre del tren, estaciones, señales y portales.
- Las señales son un punto con el peor estado de sus dos lados (el original dibuja uno por lado).
- Los trenes no se animan entre actualizaciones (CTM manda posiciones cada 0,5 s).
- Trenes y estaciones aparecen en el menú de marcadores de BlueMap: al pulsarlos, la cámara va hasta ellos
  (sustituye a la lista lateral de Dynmap).
- Sin configuración: la URL de la API se deduce sola (puerto 3876 si el mapa se abre por el 8100,
  y si no, `/api` en el mismo hostname, que es como va por el túnel de Cloudflare).

## Detalles de BlueMap que importan

- BlueMap borra cada 10 s los grupos de marcadores que no están en su `markers.json`. El script parchea
  `updateMarkerSetsFromData` para que ignore el grupo `ctm`.
- Al cambiar de mapa BlueMap vacía todos los marcadores. El script lo detecta y lo redibuja.
- Las líneas necesitan `maxDistance` explícito: sin él BlueMap usa `Number.MAX_VALUE` y no se pintan.

## Probarlo

En un servidor de prueba con el pack: copia `ctm-trains.js` a `bluemap/web/js/`, pon `"js/ctm-trains.js"`
en `scripts` de `config/bluemap/webapp.conf` y haz `/bluemap reload`. Pon vías con
`/fill 0 100 0 60 100 0 create:track[shape=xo]` (encima de un suelo) y abre `http://localhost:8100`.
Para ver trenes, estaciones y señales sin montar un tren, sustituye `EventSource` en la consola del
navegador por uno que devuelva datos falsos con el formato de `/api/*.rt`.
Ojo con la caché del navegador: recarga en una pestaña nueva o en incógnito.
