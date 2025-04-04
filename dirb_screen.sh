#!/bin/bash

# Autor  : Wintxx
# Github : https://github.com/Jean25-sys/

INPUT="$1"
OUTPUT_DIR="./capturas_web"
RESUMEN_TXT="resumen_web.txt"
DELAY=2

# Verificación de requisitos
if [[ -z "$INPUT" || ! -f "$INPUT" ]]; then
  echo " Debes ingresar un archivo de URLs como argumento."
  echo "Ejemplo: ./capturador_total.sh result_limpios.txt"
  exit 1
fi

if ! command -v whatweb &>/dev/null; then
  echo " WhatWeb no está instalado. Ejecuta: sudo apt install whatweb"
  exit 1
fi

if ! command -v chromium &>/dev/null; then
  echo " Chromium no está instalado. Ejecuta: sudo apt install chromium"
  exit 1
fi

# Preparar directorios y archivos
mkdir -p "$OUTPUT_DIR"
> "$RESUMEN_TXT"

take_screenshot() {
  local url="$1"
  local filename="$2"
  chromium --headless --no-sandbox --disable-gpu \
           --screenshot="$OUTPUT_DIR/$filename" \
           --window-size=1280,1024 "$url" > /dev/null 2>&1
}

i=0
while IFS= read -r url; do
  [[ -z "$url" ]] && continue

  status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [[ "$status_code" =~ ^(200|301|302)$ ]]; then
    echo -e "\033[1;32m[+]\033[0m ($status_code) Capturando: $url"

    safe_name=$(echo "$url" | sed 's|https\?://||;s|/|_|g')
    filename="capture_${i}_${safe_name}.png"
    take_screenshot "$url" "$filename"

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    tech=$(whatweb -q --log-brief=- "$url" \
      | sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' \
      | sed 's/,/;/g' \
      | tr -d '\n\r"' \
      | sed 's/  */ /g')

    # Consola con color
    echo -e "\n\033[1;36m[+] URL:\033[0m $url"
    echo -e "\033[1;34m[✓] Código HTTP:\033[0m $status_code"
    echo -e "\033[1;33m[✓] Captura:\033[0m $filename"
    echo -e "\033[1;32m[✓] Fecha:\033[0m $timestamp"
    echo -e "\033[1;35m[✓] Tecnologías:\033[0m"
    echo "$tech" | tr ';' '\n' | sed 's/^/   - /'
    echo -e "\033[0;90m---------------------------------------------\033[0m"

    # Guardar resumen sin colores
    {
      echo "[+] URL: $url"
      echo "[✓] Código HTTP: $status_code"
      echo "[✓] Captura: $filename"
      echo "[✓] Fecha: $timestamp"
      echo "[✓] Tecnologías:"
      echo "$tech" | tr ';' '\n' | sed 's/^/   - /'
      echo "---------------------------------------------"
    } >> "$RESUMEN_TXT"

    sleep "$DELAY"
  else
    echo -e "\033[1;31m[!]\033[0m ($status_code) Ignorado: $url"
  fi

  ((i++))
done < "$INPUT"

echo -e "\n[✓] Capturas guardadas en: $OUTPUT_DIR"
echo "[+] Resumen exportado a: $RESUMEN_TXT"
