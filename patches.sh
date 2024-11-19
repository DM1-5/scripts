#!/bin/bash
directory="$ORACLE_HOME"/scripts/patch
cd "$directory" || exit 1

if [ "$1" == "update" ]; then
  echo placeholder
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
"$ORACLE_HOME"/OPatch/opatch lsinventory > /home/oracle/oparches/opatch.log

# Envia el reporte
mail -s "host: $(hostname) Reportes de parches de seguridad linux" -a "$directory/CriticalSecurityPatches.log" -a "$directory/ImportantSecurityPatches.log" -a "$directory/opatch.log" "$MAILTO" <<EOF
$(date)

Parches Criticos: $numCrit
Parches Importantes: $numImp

EOF


