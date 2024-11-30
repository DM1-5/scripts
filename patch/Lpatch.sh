#!/bin/bash

echo "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux IP: $(hostname -I)" > Lpatch.log
date >> Lpatch.log
yum updateinfo list security all > securityPatches.log

spreport() {
  grep "$1" securityPatches.log > "$1"SecurityPatches.log
  num=$(grep -c '^' "$1"SecurityPatches.log)
  echo "- Linux Patch $1: $num" >> Lpatch.log
}

spreport Critical
spreport Important

# Envia el reporte
mail -s "$(head -n 1 Lpatch.log)" -a "CriticalSecurityPatches.log" -a "ImportantSecurityPatches.log" "$CORREO" < Lpatch.log

rm -f securityPatches.log CriticalSecurityPatches.log ImportantSecurityPatches.log Lpatch.log