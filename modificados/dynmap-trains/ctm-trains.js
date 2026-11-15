/*
 * Trenes de Create en BlueMap: vías (con ocupación), trenes, estaciones, señales y portales,
 * leídos en tiempo real de la API de Create Track Map (puerto 3876).
 *
 * Port a BlueMap de dynmap-trains (https://github.com/Zhincore/dynmap-trains, GPL-3.0).
 * Este archivo también es GPL-3.0. Cambios: ver README.md de esta carpeta.
 */
(() => {
  const bm = window.bluemap;
  if (!bm) return;
  const root = bm.mapViewer.markers;
  const SET = "ctm";

  // En la LAN (http://ip:8100) la API está en el puerto 3876. Detrás del túnel de Cloudflare
  // está en el mismo hostname que el mapa, en la ruta /api.
  const BASE = location.port === "8100" ? `${location.protocol}//${location.hostname}:3876` : "";

  const LAYERS = { blocks: "Vías", trains: "Trenes", stations: "Estaciones", signals: "Señales", portals: "Portales" };
  const DIMS = { "minecraft:overworld": "Superficie", "minecraft:the_nether": "Nether", "minecraft:the_end": "End" };
  const cache = { blocks: [], trains: [], stations: [], signals: [], portals: [] };

  // BlueMap borra cada 10 s los grupos de marcadores que no vienen en markers.json. El nuestro no.
  const update = root.updateMarkerSetsFromData.bind(root);
  root.updateMarkerSetsFromData = (data, ignore = []) => update(data, [...ignore, SET]);

  // Los mapas de BlueMap se llaman world, world_the_nether y world_the_end.
  const dimension = () => {
    const id = bm.mapViewer.map?.data.id ?? "";
    return id.includes("nether") ? "minecraft:the_nether" : id.includes("end") ? "minecraft:the_end" : "minecraft:overworld";
  };

  const rgb = (r, g, b) => ({ r, g, b, a: 1 });
  const COLORS = {
    free: rgb(255, 255, 255), reserved: rgb(255, 170, 190), occupied: rgb(255, 60, 60),
    car: rgb(0, 220, 230), lead: rgb(221, 160, 221),
    GREEN: "#71db51", YELLOW: "#ffd15c", RED: "#ff5f5c",
  };

  const esc = (s) => String(s).replace(/[&<>"']/g, (c) => `&#${c.charCodeAt(0)};`);
  const tag = (text, bg, fg) =>
    `<div style="transform:translate(-50%,-130%);white-space:nowrap;padding:1px 5px;border-radius:3px;` +
    `background:${bg};color:${fg};font:600 12px/1.4 system-ui,sans-serif">${esc(text)}</div>`;
  const dot = (color) =>
    `<div style="transform:translate(-50%,-50%);width:9px;height:9px;border-radius:50%;background:${color};border:2px solid #111"></div>`;

  // CTM manda las curvas como Bézier cúbicas (4 puntos) y las rectas como 2 puntos.
  const curve = (p) => {
    if (p.length !== 4) return p;
    const out = [];
    for (let i = 0; i <= 12; i++) {
      const t = i / 12, u = 1 - t;
      const f = (k) => u * u * u * p[0][k] + 3 * u * u * t * p[1][k] + 3 * u * t * t * p[2][k] + t * t * t * p[3][k];
      out.push({ x: f("x"), y: f("y"), z: f("z") });
    }
    return out;
  };
  // Sin maxDistance, BlueMap usa Number.MAX_VALUE y el shader no pinta la línea.
  const line = (points, lineColor, lineWidth, label) =>
    ({ type: "line", position: points[0], line: points, lineColor, lineWidth, label, depthTest: false, listed: false, maxDistance: 1e6 });
  const html = (position, html, label, listed, maxDistance) =>
    ({ type: "html", position, html, label, listed, classes: [], maxDistance });

  const render = {
    blocks: (dim) => {
      const m = {};
      for (const b of cache.blocks) {
        const color = b.occupied ? COLORS.occupied : b.reserved ? COLORS.reserved : COLORS.free;
        b.segments.forEach((s, i) => {
          if (s.dimension === dim) m[`${b.id}-${i}`] = line(curve(s.path), color, 3, "Vía");
        });
      }
      return m;
    },
    trains: (dim) => {
      const m = {};
      for (const t of cache.trains) {
        t.cars.forEach((c, i) => {
          if (c.leading?.dimension !== dim || c.trailing?.dimension !== dim) return;
          const lead = !t.stopped && i === (t.backwards ? t.cars.length - 1 : 0);
          m[`${t.id}-${i}`] = line([c.trailing.location, c.leading.location], lead ? COLORS.lead : COLORS.car, 7, t.name);
          if (i === 0) m[t.id] = html(c.leading.location, tag(t.name, "#0a5e63", "#fff"), t.name, true);
        });
      }
      return m;
    },
    stations: (dim) => Object.fromEntries(cache.stations.filter((s) => s.dimension === dim)
      .map((s) => [s.id, html(s.location, tag(s.name, "#fff", "#111"), s.name, true, 4000)])),
    signals: (dim) => Object.fromEntries(cache.signals.filter((s) => s.dimension === dim).map((s) => {
      const states = [s.forward?.state, s.reverse?.state];
      const color = states.includes("RED") ? COLORS.RED : states.includes("YELLOW") ? COLORS.YELLOW : COLORS.GREEN;
      return [s.id, html(s.location, dot(color), "Señal", false, 600)];
    })),
    portals: (dim) => Object.fromEntries(cache.portals.filter((p) => p.from.dimension === dim).map((p, i) => {
      const to = DIMS[p.to.dimension] ?? p.to.dimension;
      return [`portal-${i}`, html(p.from.location, tag(`Portal a ${to}`, "#5b2a86", "#fff"), `Portal a ${to}`, false, 4000)];
    })),
  };

  function draw(layers) {
    // BlueMap vacía todos los marcadores al cambiar de mapa: si falta nuestro grupo, se rehace entero.
    if (!root.markerSets.has(SET)) {
      root.updateMarkerSetFromData(SET, { label: "Trenes de Create", toggleable: true });
      layers = Object.keys(LAYERS);
    }
    const set = root.markerSets.get(SET);
    const dim = dimension();
    layers.forEach((k) => set.updateMarkerSetFromData(k, {
      label: LAYERS[k], toggleable: true, sorting: Object.keys(LAYERS).indexOf(k), markers: render[k](dim),
    }));
  }

  // EventSource se reconecta solo si se cae el servidor.
  const stream = (name, onData) => {
    new EventSource(`${BASE}/api/${name}.rt`).onmessage = (e) => onData(JSON.parse(e.data));
  };
  stream("network", (d) => { cache.stations = d.stations; cache.portals = d.portals; draw(["stations", "portals"]); });
  stream("blocks", (d) => { cache.blocks = d.blocks; draw(["blocks"]); });
  stream("trains", (d) => { cache.trains = d.trains; draw(["trains"]); });
  stream("signals", (d) => { cache.signals = d.signals; draw(["signals"]); });

  bm.events.addEventListener("bluemapMapChanged", () => draw(Object.keys(LAYERS)));
  setInterval(() => root.markerSets.has(SET) || draw([]), 1000);
})();
