#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

#The purpose of this script is to bypass issues trying to run the atom as a non-root user

: ${BOOMI_ATOMNAME:?"Please set BOOMI_ATOMNAME"}
: ${BOOMI_CONTAINERNAME:?"Please set BOOMI_CONTAINERNAME"}

DOCKERUSER="boomi"
DEFAULT_DOCKERUID=1000

if [ -z "${DOCKERUID}" ]; then
    DOCKERUID=$DEFAULT_DOCKERUID
fi

#set up for new boomi user to get all environment variables
mv /etc/container_environment.sh .profile
dirName=`echo ${BOOMI_CONTAINERNAME} | sed -r 's/ |-/_/g'`
echo "export DIRNAME=$dirName" >> .profile

useradd -u ${DOCKERUID} -c "Docker image user" $DOCKERUSER
chown -R $DOCKERUSER:$DOCKERUSER /home/boomi
atom_home=${INSTALLATION_DIRECTORY}/${AMC}_${dirName}
echo "export ATOM_HOME=$atom_home" >> .profile

if [[ ! -e ${atom_home} ]]; then
    mkdir ${atom_home}
fi

chown -R $DOCKERUSER:$DOCKERUSER ${atom_home}

rm -f /etc/container_environment/*

/sbin/setuser $DOCKERUSER  /home/boomi/startatom.sh
exec /sbin/setuser $DOCKERUSER  /home/boomi/attachatom.sh
