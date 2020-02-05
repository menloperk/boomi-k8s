#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

wget $URL/atom/atom_install64.sh
chmod a+x atom_install64.sh
./atom_install64.sh -q -Vusername=${BOOMI_USERNAME} -Vpassword=${BOOMI_PASSWORD} -VatomName='${BOOMI_CONTAINERNAME}' \
  -VaccountId=${BOOMI_ACCOUNTID} -VproxyHost=${PROXY_HOST} -VproxyUser=${PROXY_USERNAME} -VproxyPort=${PROXY_PORT} \
  -Vsys.symlinkDir=${SYMLINKS_DIR} -dir ${INSTALLATION_DIRECTORY} \
  > ${ATOM_HOME}/install_Atom_${DIRNAME}.log

