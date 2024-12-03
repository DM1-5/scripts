#!/bin/bash

echo "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux IP: $(hostname -I)" > Lpatch.log
date >> Lpatch.log
echo "Para ver los todos los parches por categoria revisar la ruta ~/patch">> Lpatch.log
yum updateinfo list security all > securityPatches.txt

spreport() {
  # Filtra los parches segun el argumento
  grep "$1" securityPatches.txt >> "$1"SecurityPatches.txt
  # Filtra los parches no instalados
  grep -v '^i' "$1"SecurityPatches.txt > NotInstalled"$1"SecurityPatches.txt
  # Cuenta los parches no instalados
  num=$(grep -c '^' NotInstalled"$1"SecurityPatches.txt)
  # Agrega el numero de parches no instalados al reporte
  echo "- Linux Patch $1: $num" >> Lpatch.log
  rm -f NotInstalled"$1"SecurityPatches.txt
}

spreport Critical
spreport Important

# Envia el reporte
mail -s "$(head -n 1 Lpatch.log)" -a "CriticalSecurityPatches.txt" -a "ImportantSecurityPatches.txt" "$CORREO" < Lpatch.log

#rm -f securityPatches.log CriticalSecurityPatches.log ImportantSecurityPatches.log Lpatch.log