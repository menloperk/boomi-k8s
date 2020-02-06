#!/bin/bash

curl --request POST --basic --user ${BOOMI_USERNAME}:${BOOMI_PASSWORD} --header "Content-Type: application/json" --header "Accept: application/json" --data "{ \"atomId\" : \"`sed -n -e 's/^.*\\.id=//p' ${ATOM_HOME}/conf/container.id`\", \"environmentId\" : \"${ENVIRONMENT_ID}\" }" https://api.boomi.com/api/rest/v1/${BOOMI_ACCOUNTID}/EnvironmentAtomAttachment/
