#!/bin/bash

echo "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux IP: $(hostname -I)" > Lpatch.log
date >> Lpatch.log
echo "Para ver los todos los parches por categoria revisar la ruta ~/patch">> Lpatch.log
yum updateinfo list security all > securityPatches.txt

criticalPatches="CSP($(hostname)).csv"
importantPatches="ISP($(hostname)).csv"

IP=$(hostname -I | awk '{print $1}')

spreport() {
  # Filtra los parches segun el argumento
  grep "$1" securityPatches.txt >> "$1"SecurityPatches.txt
  # Filtra los parches no instalados
  grep -v '^i' "$1"SecurityPatches.txt > NotInstalled"$1"SecurityPatches.txt
  # Cuenta los parches no instalados
  num=$(grep -c '^' NotInstalled"$1"SecurityPatches.txt)
  # Agrega el numero de parches no instalados al reporte
  echo "- Linux Patch $1: $num" >> Lpatch.log
  # HEADERs
  echo "PatchID, Severity, Description" > "$2"
  awk '{print $1","$2","$3 }' NotInstalled"$1"SecurityPatches.txt >> "$2"
  rm -f NotInstalled"$1"SecurityPatches.txt "$1""SecurityPatches.txt"
}

spreport Critical "$criticalPatches"
spreport Important "$importantPatches"

zip "$IP".zip "$criticalPatches" "$importantPatches"

subject=$(head -n 1 Lpatch.log)

# Envia el reporte
mail -s "$subject" -a "$criticalPatches" -a "$criticalPatches" -a "$IP".zip "$CORREO" < Lpatch.log

#rm -f securityPatches.log CriticalSecurityPatches.log ImportantSecurityPatches.log Lpatch.log