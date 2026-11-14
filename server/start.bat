@echo off
rem Servidor de Los Residentes (Windows). Ponlo en una carpeta vacia y haz doble clic.
rem Cada arranque instala/actualiza NeoForge y los mods desde GitHub y luego arranca el servidor.
cd /d "%~dp0"
set PACK=https://raw.githubusercontent.com/ComplicatedCraft/LosResidentesPack/main/pack.toml

for /f "usebackq delims=" %%v in (`powershell -NoProfile -Command "if ((Invoke-WebRequest -UseBasicParsing '%PACK%').Content -match 'neoforge = \"(.+)\"') { $Matches[1] }"`) do set NEO=%%v
if "%NEO%"=="" ( echo No se pudo leer pack.toml & pause & exit /b 1 )

if not exist "libraries\net\neoforged\neoforge\%NEO%" (
  echo ^>^> Instalando NeoForge %NEO%...
  curl -fsSL -o neoforge-installer.jar "https://maven.neoforged.net/releases/net/neoforged/neoforge/%NEO%/neoforge-%NEO%-installer.jar" || ( pause & exit /b 1 )
  java -jar neoforge-installer.jar --install-server . || ( pause & exit /b 1 )
  del neoforge-installer.jar neoforge-installer.jar.log 2>nul
)

findstr /r /c:"^-Xm" user_jvm_args.txt >nul 2>&1 || (echo.& echo -Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200)>> user_jvm_args.txt

echo ^>^> Sincronizando mods...
if not exist packwiz-installer-bootstrap.jar curl -fsSL -o packwiz-installer-bootstrap.jar https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar
java -jar packwiz-installer-bootstrap.jar -g -s server "%PACK%" || ( pause & exit /b 1 )

call run.bat nogui
pause
