#!/bin/bash

echo "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux IP: $(hostname -I)" > Lpatch.log
date >> Lpatch.log
echo "Para ver los todos los parches por categoria revisar la ruta ~/patch">> Lpatch.log
yum updateinfo list security all > securityPatches.log

spreport() {
  grep "$1" securityPatches.log > "$1"SecurityPatches.log
  num=$(grep -c '^' "$1"SecurityPatches.log)
  echo "- Linux Patch $1: $num" >> Lpatch.log
}

spreport Critical
spreport Important
spreport Moderate 
spreport Low

# Envia el reporte
mail -s "$(head -n 1 Lpatch.log)" -a "CriticalSecurityPatches.log" -a "ImportantSecurityPatches.log" "$CORREO" < Lpatch.log

#rm -f securityPatches.log CriticalSecurityPatches.log ImportantSecurityPatches.log Lpatch.log