#!/bin/bash
usermod --uid ${GALAXY_UID} --gid ${GALAXY_GID} --login ${GALAXY_USER} galaxy
chown -R ${GALAXY_USER} /galaxy-central /shed_tools
usermod -aG postgres ${GALAXY_USER}
usermod -aG ssl-cert ${GALAXY_USER}
# for nginx
# nginx user
sed -i -e "1c\user  ${GALAXY_USER} galaxy;" /etc/nginx/nginx.conf
## nginx port
if [ "x$GALAXY_NGINX_PORT" != "x" ]
then
  sed -i -e "s/listen 80/listen ${GALAXY_NGINX_PORT}/g" /etc/nginx/nginx.conf
fi
# for galaxy
sed -i -e "s/= galaxy/= ${GALAXY_USER}/g" /etc/supervisor/conf.d/galaxy.conf
# for postgresql
sed -i -e "s/= postgres/= ${GALAXY_USER}/g" /etc/supervisor/conf.d/galaxy.conf
## postgresql port
if [ "x$GALAXY_POSTGRES_PORT" != "x" ]
then
  sed -i -e "s/port = [0-9]*/port = ${GALAXY_POSTGRES_PORT}/g" /etc/postgresql/9.3/main/postgresql.conf
  if [ "$GALAXY_CONFIG_DATABASE_CONNECTION_NEED_REWRITE" == "true" ]
  then
    export GALAXY_CONFIG_DATABASE_CONNECTION="postgresql://galaxy:galaxy@localhost:${GALAXY_POSTGRES_PORT}/galaxy?client_encoding=utf8"
  fi
fi
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/run/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/lib/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /var/log/postgresql
chown -R ${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID} /etc/postgresql
#
sed -i -e "s/postgres:postgres/${GALAXY_POSTGRES_UID}:${GALAXY_POSTGRES_GID}/g" /usr/local/bin/export_user_files.py
# remove data_directory from postgresql.conf for persistent data
# https://github.com/bgruening/docker-galaxy-stable/commit/808623323711eb9f82190b3f65098d0d82fbbbd2
if [ "$GALAXY_APPLY_808623" == "true" ]
then
  sed -i -e "s#data_directory = '/var/lib/postgresql/9.3/main/'##" /etc/postgresql/9.3/main/postgresql.conf
fi
# maybe this is only needed on my environment
cp /etc/ssl/private/ssl-cert-snakeoil.key /etc/
chown root:ssl-cert /etc/ssl-cert-snakeoil.key
sed -i -e "s/\/ssl\/private//g" /etc/postgresql/9.3/main/postgresql.conf
mv /var/lib/postgresql/9.3/main /var/lib/postgresql/9.3/mainorg
ln -s  /var/lib/postgresql/9.3/mainorg /var/lib/postgresql/9.3/main
# apply 2790 patch
if [ "$GALAXY_APPLY_2790" == "true" ]
then
  wget --quiet -O /tmp/2790.diff https://patch-diff.githubusercontent.com/raw/galaxyproject/galaxy/pull/2790.diff
  patch -N -p1 < /tmp/2790.diff
fi

# start
/usr/bin/startup
