#!/bin/bash

# permission and environment setting on container start/restart
chmod 777 /tmp/psortm
chmod -R 777 /var/www/html/taxon_predictor
echo $MOUNT_DIRECTORY > /var/www/html/mounted_dir.conf

# Start up supervisor
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
