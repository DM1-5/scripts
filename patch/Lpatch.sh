#!/bin/bash

date > Lpatch.log
echo "Cliente: $CLIENT" >> Lpatch.log
echo "Host: $(hostname)" >> Lpatch.log
echo "Reporte: Parches de seguridad linux" >> Lpatch.log
echo "IP: $(hostname -I)" >> Lpatch.log
yum updateinfo list security all > securityPatches.log

spreport() {
  grep "$1" securityPatches.log > "$1"SecurityPatches.log
  num=$(grep -c '^' "$1"SecurityPatches.log)
  echo "Linux Patch $1: $num" >> Lpatch.log
}

spreport Critical
spreport Important

# Filtra solo los parches criticos
#grep Critical securityPatches.log > CriticalSecurityPatches.log

# Cuenta el numero de parches criticos
#numCrit=$(grep -c '^' CriticalSecurityPatches.log)

# Filtra solo los parches Importantes
#grep Important securityPatches.log > ImportantSecurityPatches.log

# Cuenta el numero de parches Importantes
#numImp=$(grep -c '^' ImportantSecurityPatches.log)

# Envia el reporte
mail -s "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux: $(hostname -I)" -a "CriticalSecurityPatches.log" -a "ImportantSecurityPatches.log" "$CORREO" < Lpatch.log