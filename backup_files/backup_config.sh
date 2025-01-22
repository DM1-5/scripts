#!/bin/bash

# Variables
ymd=$(date +%Y-%m-%d)
tim=$(date +%H:%M:%S)
obj=$1  
bucket_name=$2
bkpdir="/u01/orabackups"     
backup_name="backup.config.$obj.$ymd.tar.gz"  

mkdir -p /u01/orabackups/configuration/$obj/crontab 
mkdir -p /u01/orabackups/configuration/$obj/dbs 
mkdir -p /u01/orabackups/configuration/$obj/network_admin 
mkdir -p /u01/orabackups/configuration/$obj/scripts 
mkdir -p /u01/orabackups/configuration/$obj/tde_wallet 

/usr/bin/crontab -l > /home/oracle/crontab.out
cp /home/oracle/crontab.out /u01/orabackups/configuration/$obj/crontab
cp -R $ORACLE_HOME/dbs/* /u01/orabackups/configuration/$obj/dbs
cp -R $ORACLE_HOME/network/admin/* /u01/orabackups/configuration/$obj/network_admin
cp -R /home/oracle/scripts/* /u01/orabackups/configuration/$obj/scripts
cp -R /opt/oracle/dcs/commonstore/wallets/tde/$ORACLE_UNQNAME/* /u01/orabackups/configuration/$obj/tde_wallet

cd /u01/orabackups/configuration
tar -czf $bkpdir/$backup_name $obj

echo "Subiendo el archivo comprimido al Bucket..."
~/bin/oci os object put -ns surapanama -bn $bucket_name --file $bkpdir/$backup_name --name $obj/$backup_name 

tim=$(date +%H:%M:%S) 
echo "------------------------------------------------------" >> $bkpdir/backups.log
echo "$ymd $tim $obj BACKUP ENDED..." >> $bkpdir/backups.log

rm -rf /u01/orabackups/configuration/$obj