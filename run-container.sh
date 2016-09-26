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



docker run -d \
           --name ${GALAXY_CONTAINER_NAME} \
           --hostname ${GALAXY_CONTAINER_HOSTNAME} \
           -e GALAXY_USER=${GALAXY_USER} \
           -e GALAXY_UID=${GALAXY_UID} \
           -e GALAXY_POSTGRES_UID=${GALAXY_POSTGRES_UID} \
           -p 20080:80 -p 29002:9002  -e NONUSE="condor" \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD/export:/export \
           -v $PWD/setup.sh:/galaxy-central/setup.sh \
           ${GALAXY_CONTAINER} \
           /galaxy-central/setup.sh
