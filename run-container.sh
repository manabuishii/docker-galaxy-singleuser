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


docker run -e GALAXY_USER=${GALAXY_USER} -e GALAXY_UID=${GALAXY_UID} -e GALAXY_POSTGRES_UID=${GALAXY_POSTGRES_UID} -p 20080:80 -p 29002:9002  -e NONUSE="condor" \
           -v $PWD/job_conf.xml.local:/etc/galaxy/job_conf.xml \
           -v $PWD/export:/export -v $PWD/setup.sh:/galaxy-central/setup.sh --rm bgruening/galaxy-stable:dev /galaxy-central/setup.sh