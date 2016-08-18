#!/bin/bash
usermod --uid ${GALAXY_UID} --gid ${GALAXY_GID} --login ${GALAXY_USER} galaxy
chown -R ${GALAXY_USER} /galaxy-central /shed_tools
usermod -aG postgres ${GALAXY_USER}
usermod -aG ssl-cert ${GALAXY_USER}
# for nginx
sed -i -e "1c\user  ${GALAXY_USER} galaxy;" /etc/nginx/nginx.conf
# for galaxy
sed -i -e "s/= galaxy/= ${GALAXY_USER}/g" /etc/supervisor/conf.d/galaxy.conf
# for postgresql
sed -i -e "s/= postgres/= ${GALAXY_USER}/g" /etc/supervisor/conf.d/galaxy.conf
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/run/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/lib/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/log/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /etc/postgresql
#
sed -i -e "s/postgres:postgres/${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID}/g" /usr/local/bin/export_user_files.py
# maybe this is only needed on my environment
cp /etc/ssl/private/ssl-cert-snakeoil.key /etc/
chown root:ssl-cert /etc/ssl-cert-snakeoil.key
sed -i -e "s/\/ssl\/private//g" /etc/postgresql/9.3/main/postgresql.conf
mv /var/lib/postgresql/9.3/main /var/lib/postgresql/9.3/mainorg
ln -s  /var/lib/postgresql/9.3/mainorg /var/lib/postgresql/9.3/main
# start
/usr/bin/startup
