#!/bin/bash

if [ "$(whoami)" != "oracle" ]; then
  echo "Este script debe ser ejecutado por el usuario oracle"
  exit 1
fi

criticalPatches="CSP($(hostname)).csv"
importantPatches="ISP($(hostname)).csv"
opatchPatches="Opatch($(hostname)).csv"

dir=/home/oracle/scripts/patch
cd "$dir" || exit 1

# la definicion de MAILTO y CLIENT se encuentra en el archivo config.conf
source /home/oracle/scripts/patch/config.conf

if [ "$1" == "update" ]; then
  wget -O patches.sh https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/patches.sh --no-check-certificate
  if [ $? -ne 0 ]; then
    echo "Error al descargar el archivo patches.sh"
    echo "wget esta instalado?"
    exit 1
  fi
  wget -O opatch_summary.sh https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/opatch_summary.sh --no-check-certificate
  if [ $? -ne 0 ]; then
    echo "Error al descargar el archivo opatch_summary.sh"
    echo "wget esta instalado?"
    exit 1
  fi
  chmod +x patches.sh 
  chmod +x opatch_summary.sh 
  exit 0
fi

date > patches.log
# Crea el archivo que contiene todos los patches por aplicar
yum updateinfo list security all > securityPatches.txt

spreport() {
  # Filtra los parches segun el argumento
  grep "$1" securityPatches.txt >> "$1"SecurityPatches.txt
  # Filtra los parches no instalados
  grep -v '^i' "$1"SecurityPatches.txt > NotInstalled"$1"SecurityPatches.txt
  # Cuenta los parches no instalados
  num=$(grep -c '^' NotInstalled"$1"SecurityPatches.txt)
  # Agrega el numero de parches no instalados al reporte
  echo "- Linux Patch $1: $num" >> patches.log
  # HEADERs
  echo "PatchID, Severity, Description" > "$2"
  awk '{print $1","$2","$3 }' NotInstalled"$1"SecurityPatches.txt >> "$2"
  rm -f NotInstalled"$1"SecurityPatches.txt "$1""SecurityPatches.txt"
}

spreport Critical "$criticalPatches"
spreport Important "$importantPatches"

# Crea el archivo que contiene todos los parches aplicados
# headers
echo 'Patch#|Applied_Date|Description' > $dir/Patches_de_Binarios_Oracle.csv
sh opatch_summary.sh --csv >> $dir/"$opatchPatches"
#head -n 1 $dir/Patches_de_Binarios_Oracle.csv >> patches.log

# Crea un reporte de todos los procesos Oracle corriendo en el servidor
ps -ef | grep -v grep | grep pmon | awk '{print $8}' > pmon.log
echo "Procesos Oracle-Pmon corriendo en el servidor:" >> patches.log
cat pmon.log >> patches.log

# Envia el reporte
mail -s "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux y Oracle IP: $(hostname -I)" -a "$dir/$criticalPatches" -a "$dir/$importantPatches" -a "$dir/$opatchPatches" "$MAILTO" < patches.log


