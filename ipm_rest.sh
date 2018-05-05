#!/bin/bash

# GET example: ./ipm_rest.sh GET '1.0/topology/mgmt_artifacts/UxCrquDzYTeqK-zrMivHyA/references/to/contains' 
# POST example: ./ipm_rest.sh POST 1.0/topology/mgmt_artifacts '{"arbitraryStringProperty":"A string is here","description":"Custom group description","displayLabel":"MyGroup2","keyIndexName":"group2"}'

config="ipm_rest.config"
rtype=${1}
uri=${2}
data=${3}

# get config
. ${config}

# remove any leading slash from uri
if [ "x$uri" != "x" ]; then
	if [[ $uri == /* ]]; then
		uri=${uri#"/"}
		echo "uri is ${uri}"
	fi 	
fi

# make request

# no payload
if [ "x$data" = "x" ]; then
	CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}:8091/${uri}'  --header 'accept: application/json' --header 'Referer: https://${apmhost}:8091' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json'"
else
# with payload
	CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}:8091/${uri}'  --header 'accept: application/json' --header 'Referer: https://${apmhost}:8091' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json' --data '${data}'"
fi

echo "running: ${CMD}"
eval ${CMD}
