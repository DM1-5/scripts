#!/bin/bash

dir=/home/oracle/scripts/patch
cd "$dir" || exit 1

if ! [ -f "$dir"/config.conf ]; then
  echo "No se encontro el archivo de configuracion, edita config.conf"
  touch config.conf
  exit 1
else 
  source "$dir"/config.conf
fi

if [ "$1" == "update" ]; then
  #wget -O patches.sh https://raw.githubusercontent.com/DM1-5/scripts/main/patches.sh
  wget -O opatch_summary.sh https://raw.githubusercontent.com/wayneadamsconsulting/oracle-opatch_summary/refs/heads/master/opatch_summary.sh
  chmod +x patches.sh
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
sh opatch_summary.sh > $dir/opatch.log

# Envia el reporte
mail -s "host: $(hostname) Reportes de parches de seguridad linux" -a "$dir/CriticalSecurityPatches.log" -a "$dir/ImportantSecurityPatches.log" -a "$dir/opatch.log" "$MAILTO" <<EOF
$(date)
$(head -n 1 $dir/opatch.log)
Parches Criticos: $numCrit
Parches Importantes: $numImp

EOF


