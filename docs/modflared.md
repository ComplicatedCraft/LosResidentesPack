# Modflared: entrar al servidor por Cloudflare Tunnel

Con un Cloudflare Tunnel, el servidor se publica en tu dominio (por ejemplo `mc.tudominio.com`) **sin abrir puertos en el router**. El problema es que Cloudflare no deja que el juego se conecte directamente al túnel: el cliente necesita el programa `cloudflared` para "entrar" en él.

[Modflared](https://modrinth.com/mod/modflared) resuelve eso desde dentro del juego. **Ya viene en el pack** (solo cliente), así que los jugadores no tienen que instalar nada.

## Cómo funciona

1. El jugador añade `mc.tudominio.com` como un servidor normal y le da a *Unirse*.
2. Modflared busca un registro **TXT** en el DNS de ese nombre. Si encuentra `cloudflared-use-tunnel`, sabe que ese servidor va por túnel.
3. Si hace falta, descarga `cloudflared` desde el GitHub oficial de Cloudflare, en la versión para el sistema del jugador (Windows, Linux o macOS). Lo guarda en la carpeta `modflared/` del juego.
4. Abre un túnel local (`cloudflared access tcp`) y conecta el juego a través de él. Para el jugador es transparente.

Si el servidor no tiene ese registro TXT, Modflared no hace nada y el juego se conecta como siempre. Por eso no estorba con servidores normales.

---

## Para el administrador: configurarlo una vez

Hace falta un dominio gestionado en Cloudflare (plan gratuito) y el stack del servidor con el túnel activado. Esto último está en el README, en *Servidor → Cloudflare Tunnel*.

### 1. Ruta del juego en el túnel

En [Cloudflare Zero Trust](https://one.dash.cloudflare.com): **Networks → Tunnels →** tu túnel **→ Public Hostname → Add a public hostname**:

| Campo | Valor |
|---|---|
| Subdomain | `mc` |
| Domain | `tudominio.com` |
| Service → Type | `TCP` |
| Service → URL | `crafty:25565` |

> `crafty` es el nombre del contenedor del panel dentro de Docker. Si no usas el stack del panel y `cloudflared` corre directamente en el ordenador, pon `localhost:25565`.

Al guardar, Cloudflare crea solo el registro DNS `mc` (un CNAME hacia `<id-del-túnel>.cfargotunnel.com`).

### 2. Registro TXT para Modflared

En el panel normal de Cloudflare: **tu dominio → DNS → Records → Add record**:

| Campo | Valor |
|---|---|
| Type | `TXT` |
| Name | `mc` |
| Content | `cloudflared-use-tunnel` |

Este registro es lo que le dice a Modflared "este servidor va por túnel".

#### Variante: nombre bonito y túnel en otro nombre

Si quieres que los jugadores pongan un nombre (por ejemplo `residentes.tudominio.com`) y que el túnel esté en otro (`mc.tudominio.com`), pon en el TXT de **`residentes`**:

```
cloudflared-route=mc.tudominio.com
```

### 3. Comprobarlo

Desde cualquier ordenador:

```sh
nslookup -type=TXT mc.tudominio.com      # debe salir "cloudflared-use-tunnel"
```

Después entra con el juego a `mc.tudominio.com`. En el log del cliente (`logs/latest.log`) deben salir líneas de Modflared descargando o usando `cloudflared` y abriendo el túnel.

> El DNS puede tardar unos minutos en propagarse tras crear los registros.

---

## Para los jugadores

1. Abre el juego con el pack (Modflared ya está dentro).
2. *Multijugador → Añadir servidor →* dirección `mc.tudominio.com` (sin puerto).
3. Entra. La primera vez puede tardar unos segundos más mientras descarga `cloudflared`.

### Si no conecta

- **¿El admin puso el registro TXT?** Si no, puedes forzar el túnel tú mismo. En la carpeta del juego (la de la instancia, donde están `mods/` y `config/`) crea `modflared/forced_tunnels.json` con:
  ```json
  ["mc.tudominio.com"]
  ```
  y reinicia el juego.
- **Antivirus o firewall:** Modflared ejecuta `cloudflared`, que el antivirus puede bloquear. Permítelo. El binario está en la carpeta `modflared/` del juego.
- **macOS:** si el sistema bloquea `cloudflared` por ser "de un desarrollador no identificado", permítelo en *Ajustes del Sistema → Privacidad y seguridad*.
- **Plan B:** entra por la IP con el puerto abierto, por playit.gg o por Tailscale, si el admin los tiene.

---

## Limitaciones

- **Solo TCP.** El canal UDP de Sable (barcos y aviones de Create Aeronautics) no pasa por el túnel y se usa TCP, con algo más de latencia en las naves.
- **Más ping** que conectando directo, porque todo pasa por la red de Cloudflare. Si el admin puede abrir el puerto 25565 en el router, para jugar es mejor.
- **Modflared avisa de que no está probado del todo.** Si da guerra, usa el plan B.
- **Ten un plan B listo:** que el túnel funcione depende de Cloudflare y de que Modflared consiga descargar `cloudflared` desde GitHub.
