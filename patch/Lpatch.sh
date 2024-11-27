#!/bin/bash

date > Lpatch.log
yum updateinfo list security all > securityPatches.log

spreport() {
  grep "$1" securityPatches.log > "$1"SecurityPatches.log
  num=$(grep -c '^' CriticalSecurityPatches.log)
  echo "Linux Parches $1: $num" >> Lpatch.log
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