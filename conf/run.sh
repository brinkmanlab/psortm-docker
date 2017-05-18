#!/bin/bash

# permission and environment setting on container start/restart
chmod 777 /tmp/psortm
chmod -R 777 /var/www/html/taxon_predictor
sed -e "s/20/60/g" < /etc/init.d/apache2.orig > /etc/init.d/apache2 && chmod 755 /etc/init.d/apache2
echo $MOUNT_DIRECTORY > /var/www/html/mounted_dir.conf

# Start up supervisor
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
