#!/bin/bash
if [ ! -d "export" ]; then
  mkdir export
fi
if [ "x$GALAXY_USER" == "x" ]
    then
        GALAXY_USER=$(whoami)
fi
if [ "x$GALAXY_POSTGRES_UID" == "x" ]
    then
        GALAXY_POSTGRES_UID=$(id -u)
fi
if [ "x$GALAXY_UID" == "x" ]
    then
        GALAXY_UID=$(id -u)
fi
if [ "x$GALAXY_CONTAINER" == "x" ]
    then
        GALAXY_CONTAINER=bgruening/galaxy-stable:dev
fi
if [ "x$GALAXY_CONTAINER_NAME" == "x" ]
    then
        GALAXY_CONTAINER_NAME=galaxytest
fi
if [ "x$GALAXY_CONTAINER_HOSTNAME" == "x" ]
    then
        GALAXY_CONTAINER_HOSTNAME=galaxytest
fi
#
if [ "x$GALAXY_CONFIG_DATABASE_CONNECTION" == "x" ]
then
  if [ "x$GALAXY_POSTGRES_PORT" != "x" ]
  then
    # if there is no user set GALAXY_CONFIG_DATABASE_CONNECTION
    GALAXY_CONFIG_DATABASE_CONNECTION_NEED_REWRITE="true"
  fi
else
  # setup own settings for database connection
  GALAXY_OPTIONS="-e GALAXY_CONFIG_DATABASE_CONNECTION=${GALAXY_CONFIG_DATABASE_CONNECTION}"
fi
#
# if it is not set, set --hostname , -p 20080:80 and -p 29002:9002
#
if [ "x$GALAXY_CONTAINER_NET_OPTION" == "x" ]
then
  GALAXY_CONTAINER_NET_OPTION="--hostname ${GALAXY_CONTAINER_HOSTNAME} -p 20080:80 -p 29002:9002"
fi
#
if [ "x$NONUSE" == "x" ]
then
  NONUSE="condor,proftp,reports,nodejs"
fi


#
docker run -d \
           --name ${GALAXY_CONTAINER_NAME} \
           ${GALAXY_CONTAINER_NET_OPTION} \
           -e GALAXY_CONFIG_FILE_PATH=$PWD/export/galaxy-central/database/files \
           -e GALAXY_CONFIG_JOB_WORKING_DIRECTORY=$PWD/export/galaxy-central/database/job_working_directory \
           -e SGE_ROOT=/var/lib/gridengine \
           -e GALAXY_APPLY_808623=${GALAXY_APPLY_808623} \
           -e GALAXY_CLEANUP_JOB_NEVER=${GALAXY_CLEANUP_JOB_NEVER} \
           -e GALAXY_APPLY_2790=${GALAXY_APPLY_2790} \
           -e GALAXY_USER=${GALAXY_USER} \
           -e GALAXY_UID=${GALAXY_UID} \
           -e GALAXY_POSTGRES_UID=${GALAXY_POSTGRES_UID} \
           -e GALAXY_NGINX_PORT=${GALAXY_NGINX_PORT} \
           -e GALAXY_POSTGRES_PORT=${GALAXY_POSTGRES_PORT} \
           ${GALAXY_OPTIONS} \
           -e GALAXY_CONFIG_DATABASE_CONNECTION_NEED_REWRITE=${GALAXY_CONFIG_DATABASE_CONNECTION_NEED_REWRITE} \
           -e NONUSE=${NONUSE} \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD:$PWD \
           -e SGE_MASTER_HOST=$SGE_MASTER_HOST \
           -v $PWD/export:/export \
           -v $PWD/setup.sh:/galaxy-central/setup.sh \
           ${GALAXY_CONTAINER} \
           /galaxy-central/setup.sh
