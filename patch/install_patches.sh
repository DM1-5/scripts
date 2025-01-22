#!/bin/bash

if [ "$(whoami)" != "oracle" ]; then
  echo "Este script debe ser ejecutado por el usuario oracle"
  exit 1
fi

# Variables
SCRIPTS_DIR=/home/oracle/scripts
INSTALL_DIR=$SCRIPTS_DIR/patch
CONFIG_FILE=$INSTALL_DIR/config.conf
PATCHES_URL=https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/patches.sh 
OPATCH_SUMMARY_URL=https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/opatch_summary.sh

yum install wget -y 
yum install unzip -y


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
wget -O patches.sh "$PATCHES_URL" --no-check-certificate
chmod +x patches.sh
wget -O opatch_summary.sh "$OPATCH_SUMMARY_URL" --no-check-certificate
chmod +x opatch_summary.sh

echo "Instalacion completada. $INSTALL_DIR"