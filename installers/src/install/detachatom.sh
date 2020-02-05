#!/bin/bash

source .profile

ATOM_ID=`sed -n -e 's/^.*\\.id=//p' ${ATOM_HOME}/conf/container.id`

curl --request DELETE --basic --user ${BOOMI_USERNAME}:${BOOMI_PASSWORD} --header "Content-Type: application/json" --header "Accept: application/json" https://api.boomi.com/api/rest/v1/${BOOMI_ACCOUNTID}/EnvironmentAtomAttachment/`echo -n ENV_CONT_ATTACH${ATOM_ID}:${ENVIRONMENT_ID} | base64 -w 0`
