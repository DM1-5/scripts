#!/bin/bash

dir=/home/oracle/scripts/patch
cd "$dir" || exit 1

# la definicion de MAILTO y CLIENT se encuentra en el archivo config.conf
source /home/oracle/scripts/patch/config.conf

if [ "$1" == "update" ]; then
  wget -O patches.sh https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/patches.sh
  wget -O opatch_summary.sh https://raw.githubusercontent.com/DM1-5/scripts/refs/heads/main/patch/opatch_summary.sh
  chmod +x patches.sh
  chmod +x opatch_summary.sh
  exit 0
fi

# Crea el archivo que contiene todos los patches por aplicar
yum updateinfo list security all > securityPatches.log

# Filtra solo los parches criticos
grep Critical securityPatches.log > CriticalSecurityPatches.log

# Cuenta el numero de parches criticos
numCrit=$(grep -c '^' CriticalSecurityPatches.log)

# Filtra solo los parches Importantes
grep Important securityPatches.log > ImportantSecurityPatches.log

# Cuenta el numero de parches Importantes
numImp=$(grep -c '^' ImportantSecurityPatches.log)

# Crea el archivo que contiene todos los parches aplicados
sh opatch_summary.sh > $dir/Patches_de_Binarios_Oracle.log

ps -ef | grep -v grep | grep pmon | awk '{print $8}' > pmon.log

# Envia el reporte
mail -s "Cliente: $CLIENT Host: $(hostname) Reporte: Parches de seguridad linux y Oracle" -a "$dir/CriticalSecurityPatches.log" -a "$dir/ImportantSecurityPatches.log" -a "$dir/Patches_de_Binarios_Oracle.log" "$MAILTO" <<EOF
$(date)
$(head -n 1 $dir/opatch.log)
# Linux Parches Criticos: 
$numCrit
# Linux Parches Importantes: 
$numImp
# Procesos Oracle-Pmon corriendo en el servidor:
$(cat pmon.log)
EOF

rm -f securityPatches.log CriticalSecurityPatches.log ImportantSecurityPatches.log opatch.log 

