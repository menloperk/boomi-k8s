#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

source .profile

if [[ ! -f ${ATOM_HOME}/conf/container.id ]];
then

    sh /home/boomi/install.sh
#    sed -i '/export BOOMI_PASSWORD=/d' /home/boomi/.profile
#    export BOOMI_PASSWORD=

    rm -f ${ATOM_HOME}/.install4j/pref_jre.cfg
    rm -f ${ATOM_HOME}/.install4j/inst_jre.cfg

    mv /home/boomi/atom ${ATOM_HOME}/bin
    ln -s ${ATOM_HOME}/bin/atom /usr/local/bin/atom

    #make sure everything is still ok now that we've overwritten atom script
    atom restart

else
    rm /home/boomi/atom
    ln -s ${ATOM_HOME}/bin/atom /usr/local/bin/atom
    atom start
fi

atom status

exit 0
