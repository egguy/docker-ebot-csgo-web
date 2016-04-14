#!/bin/sh

echo "Preparing ebot in 10 secondes"
echo ${homedir}
sleep 10
cd ${homedir}/ebot-csgo-web
ls 
php symfony configure:database 'mysql:host=mysql;dbname=ebotv3' ebotv3 ebotv3
php symfony doctrine:insert-sql
php symfony guard:create-user --is-super-admin admin@ebot admin password
php symfony cc
rm -rf /home/ebotv3-web/ebot-csgo-web/web/installation
