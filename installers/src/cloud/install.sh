#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

: ${BOOMI_CLOUDID:?"Please set BOOMI_CLOUDID"}
wget $URL/atom/cloud_install64.sh
chmod a+x cloud_install64.sh
./cloud_install64.sh -q -Vusername=${BOOMI_USERNAME} -Vpassword=${BOOMI_PASSWORD} -VatomName='${BOOMI_CONTAINERNAME}' \
  -VaccountId=${BOOMI_ACCOUNTID} -VcloudId=${BOOMI_CLOUDID} -VproxyHost=${PROXY_HOST} -VproxyUser=${PROXY_USERNAME} \
  -VproxyPassword=${PROXY_PASSWORD} -VproxyPort=${PROXY_PORT} -VlocalTempPath=${LOCAL_TEMP_PATH} \
  -VlocalPath=${LOCAL_PATH} -Vsys.symlinkDir=${SYMLINKS_DIR} -dir ${INSTALLATION_DIRECTORY} \
  > ${ATOM_HOME}/install_Cloud_${DIRNAME}.log
