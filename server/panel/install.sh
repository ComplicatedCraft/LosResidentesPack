#!/usr/bin/env bash
# Instala el servidor de Los Residentes con panel (Crafty) + SFTP en Linux Mint / Ubuntu / Debian.
# Uso (con la cuenta que ya existe en el ordenador, pedirá la contraseña de sudo):
#   curl -fsSL https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/server/panel/install.sh | bash
# Todo queda en ~/losresidentes. Para desinstalar: cd ~/losresidentes && sudo docker compose down && rm -rf ~/losresidentes
set -euo pipefail
REPO=https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main
DIR="$HOME/losresidentes"

echo ">> Instalando Docker (paquetes de la distribución)..."
command -v docker >/dev/null || { sudo apt-get update && sudo apt-get install -y docker.io; }
docker compose version >/dev/null 2>&1 || sudo docker compose version >/dev/null 2>&1 || sudo apt-get install -y docker-compose-v2
sudo systemctl enable --now docker

echo ">> Preparando $DIR..."
mkdir -p "$DIR"/crafty/{backups,logs,servers,config,import}
cd "$DIR"
curl -fsSL -o docker-compose.yml "$REPO/server/panel/docker-compose.yml"
curl -fsSL -o crafty/import/LosResidentes-Server.zip \
  https://github.com/ComplicatedCraft/LosResidentesPack/releases/latest/download/LosResidentes-Server.zip
if [ ! -f .env ]; then
  echo "SFTP_PASSWORD=$(python3 -c 'import secrets; print(secrets.token_urlsafe(15))')" > .env
  chmod 600 .env
fi

if ! grep -q '^CF_TUNNEL_TOKEN=' .env; then
  echo
  echo "Cloudflare Tunnel (opcional): publica el panel, el juego y el mapa en tu dominio sin abrir puertos."
  read -r -p "Pega el token del túnel (Zero Trust → Networks → Tunnels), o Enter para saltar: " t </dev/tty || t=""
  if [ -n "$t" ]; then
    printf 'CF_TUNNEL_TOKEN=%s\nCOMPOSE_PROFILES=tunnel\n' "$t" >> .env
  fi
fi

echo ">> Arrancando contenedores..."
sudo docker compose pull -q
sudo docker compose up -d

echo ">> Esperando a que Crafty genere la contraseña inicial..."
for _ in $(seq 1 60); do [ -f crafty/config/default-creds.txt ] && break; sleep 3; done

IP=$(hostname -I | awk '{print $1}')
echo
echo "================ LISTO ================"
echo "Panel:  https://$IP:8443   (el navegador avisará del certificado: es normal, acéptalo)"
sudo cat crafty/config/default-creds.txt 2>/dev/null | grep -E '"(username|password)"' || echo "  (credenciales: sudo cat $DIR/crafty/config/default-creds.txt)"
echo "SFTP:   sftp://$IP:2222   usuario: admin   contraseña: $(sed -n 's/^SFTP_PASSWORD=//p' .env)"
grep -q '^COMPOSE_PROFILES=tunnel' .env && echo "Cloudflare Tunnel: activo (configura las rutas en Zero Trust, ver README)"
echo "Siguiente paso: crear el servidor en el panel (ver README, sección 'Servidor con panel')."
echo
if ! command -v tailscale >/dev/null; then
  read -r -p "¿Instalar Tailscale para entrar al panel desde fuera de casa? [s/N] " r </dev/tty || r=n
  if [[ "$r" =~ ^[sS]$ ]]; then
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
    echo "Tailscale: entra al panel con https://$(tailscale ip -4 | head -1):8443"
  fi
fi
