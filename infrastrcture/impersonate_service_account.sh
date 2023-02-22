#!/bin/bash

if [[ $BASH_SOURCE = */* ]]; then
    scriptDir=${BASH_SOURCE%/*}
else
    scriptDir=.
fi
echo "The script is located in ${scriptDir}"

credentialsDir="${scriptDir}/.gcp_config"
echo "Generating credentials at ${credentialsDir}"

mkdir -p ${credentialsDir}
accessToken=$(gcloud auth print-access-token --impersonate-service-account=gke-admin@tf-serving-exploration.iam.gserviceaccount.com)
echo ${accessToken} | tr -d '\n'  > ${credentialsDir}/credentials