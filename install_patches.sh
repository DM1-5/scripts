#!/bin/bash

# Variables
SCRIPTS_DIR=/home/oracle/scripts
INSTALL_DIR=$SCRIPTS_DIR/patch
CONFIG_FILE=$INSTALL_DIR/config.conf
PATCHES_URL=https://raw.githubusercontent.com/DM1-5/scripts/main/patches.sh
OPATCH_SUMMARY_URL=https://raw.githubusercontent.com/wayneadamsconsulting/oracle-opatch_summary/refs/heads/master/opatch_summary.sh

if [ -d $SCRIPTS_DIR ]; then
  echo "El directorio $SCRIPTS_DIR ya existe"
  echo "Creando el directorio $INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
else
  echo "El directorio $SCRIPTS_DIR no existe, verificar la ruta" || exit 1
fi

cd "$INSTALL_DIR" || exit 1

if ! [ -f "$CONFIG_FILE" ]; then
  echo "No se encontro el archivo de configuracion, creando config.conf"
  touch "$CONFIG_FILE"
fi

echo "Descargando scripts..."
wget -O patches.sh "$PATCHES_URL"
chmod +x patches.sh
wget -O opatch_summary.sh "$OPATCH_SUMMARY_URL"
chmod +x opatch_summary.sh

echo "Installation complete. Scripts have been downloaded to $INSTALL_DIR"