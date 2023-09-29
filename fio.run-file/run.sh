#!/bin/bash

# user configurable options #####################################################

# remotehost to test
remote_host=foo.example.com

# set the number of samples for your run
samples=3

# userenv to build containers using
userenv="rhubi8"

#################################################################################

if [ -z "$(command -v jq)" ]; then
    echo "ERROR: This script requires jq to edit the run-file JSON"
    echo "       Either install jq and re-run or manually edit the JSON and"
    echo "       invoke with the execution command below"
    exit 1
fi

pushd $(dirname $0) > /dev/null

function replace_value() {
    local variable=$1; shift
    local value=$1; shift
    local query=$1; shift

    jq --arg ${variable} "${value}" "${query}" fio.json > fio.json.tmp
    mv fio.json.tmp fio.json
}

replace_value remote_host ${remote_host} '."endpoints"[0]."host" = $remote_host'

replace_value userenv ${userenv} '."endpoints"[0]."userenv" = $userenv'

replace_value samples ${samples} '."run-params"."num-samples" = $samples'

replace_value samples ${samples} '."run-params"."max-sample-failures" = $samples'

## execution command
crucible run --from-file fio.json
