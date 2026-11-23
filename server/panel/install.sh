#!/usr/bin/env bash
# Instala el servidor de Los Residentes (Docker: servidor + copias + SFTP) en Linux Mint / Ubuntu / Debian.
# Uso (con la cuenta que ya existe en el ordenador, pedirá la contraseña de sudo):
#   curl -fsSL https://losresidentespack.pages.dev/server/panel/install.sh | bash
# Todo queda en ~/losresidentes. Para desinstalar: cd ~/losresidentes && sudo docker compose down && rm -rf ~/losresidentes
set -euo pipefail
REPO=https://losresidentespack.pages.dev
DIR="$HOME/losresidentes"

echo ">> Instalando Docker (paquetes de la distribución)..."
command -v docker >/dev/null || { sudo apt-get update && sudo apt-get install -y docker.io; }
docker compose version >/dev/null 2>&1 || sudo docker compose version >/dev/null 2>&1 || sudo apt-get install -y docker-compose-v2
sudo systemctl enable --now docker

echo ">> Preparando $DIR..."
mkdir -p "$DIR"/{data,backups,rclone}
cd "$DIR"
curl -fsSL -o docker-compose.yml "$REPO/server/panel/docker-compose.yml"
if [ ! -f .env ]; then
  echo "SFTP_PASSWORD=$(python3 -c 'import secrets; print(secrets.token_urlsafe(15))')" > .env
  chmod 600 .env
fi

if ! grep -q '^CF_TUNNEL_TOKEN=' .env; then
  echo
  echo "Cloudflare Tunnel (opcional): publica el juego y el mapa en tu dominio sin abrir puertos."
  read -r -p "Pega el token del túnel (Zero Trust → Networks → Tunnels), o Enter para saltar: " t </dev/tty || t=""
  if [ -n "$t" ]; then
    printf 'CF_TUNNEL_TOKEN=%s\nCOMPOSE_PROFILES=tunnel\n' "$t" >> .env
  fi
fi

echo ">> Arrancando contenedores..."
sudo docker compose pull -q
sudo docker compose up -d

IP=$(hostname -I | awk '{print $1}')
echo
echo "================ LISTO ================"
echo "El servidor está descargando NeoForge y los mods. Mira cómo va con:"
echo "  cd $DIR && sudo docker compose logs -f minecraft      (listo cuando salga \"Done (\")"
echo "Juego:  $IP:25565"
echo "SFTP:   sftp://$IP:2222   usuario: admin   contraseña: $(sed -n 's/^SFTP_PASSWORD=//p' .env)"
grep -q '^COMPOSE_PROFILES=tunnel' .env && echo "Cloudflare Tunnel: activo (configura las rutas en Zero Trust, ver README)"
echo
if ! command -v tailscale >/dev/null; then
  read -r -p "¿Instalar Tailscale para entrar por SFTP desde fuera de casa? [s/N] " r </dev/tty || r=n
  if [[ "$r" =~ ^[sS]$ ]]; then
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
    echo "Tailscale: SFTP en sftp://$(tailscale ip -4 | head -1):2222"
  fi
fi
