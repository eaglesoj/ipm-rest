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
	fi 	
fi

# make request

# no payload
if [ "x$data" = "x" ]; then
	if [[ $apmhost != *"api.ibm.com"* ]]; then
		# on prem
		CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}:8091/${uri}'  --header 'accept: application/json' --header 'Referer: https://${apmhost}:8091' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json'"
	else
		# cloud
		CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}/perfmgmt/run/${uri}'  --header 'accept: application/json' --header 'Referer: https://api.ibm.com' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json' --header 'x-ibm-client-id: ${clientid}' --header 'x-ibm-client-secret: ${clientsecret}' --header 'x-ibm-service-location: ${servicelocation}'"
	fi
else
# with payload
	if [[ $apmhost != *"api.ibm.com"* ]]; then
		# on prem
		CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}:8091/${uri}'  --header 'accept: application/json' --header 'Referer: https://${apmhost}:8091' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json' --data '${data}'"
	else
		#cloud
		CMD="curl --tlsv1.2 -s -v -k --request ${rtype} --url 'https://${apmhost}/perfmgmt/run/${uri}'  --header 'accept: application/json' --header 'Referer: https://api.ibm.com' --header \"authorization: Basic ${auth}\" --header 'content-type: application/json'  --header 'x-ibm-client-id: ${clientid}' --header 'x-ibm-client-secret: ${clientsecret}' --header 'x-ibm-service-location: ${servicelocation}' --data '${data}'"
	fi
fi

echo "running: ${CMD}"
eval ${CMD}
