#!/bin/bash

config=$1
if [ -z "$config" ]; then
    echo "config file not specified.  Use ./run.sh <your-config-file>"
    exit 1
fi
if [ ! -e $config ]; then
    echo "Could not find $config, exiting"
    exit 1
fi
. $config

if [ -z "$tags" ]; then
    echo "You must define tags in your config file"
    exit 1
fi

if [ -z "$ocp_host" ]; then
    echo "You must define ocp_host in your config file"
    exit 1
fi

if [ -z "$num_samples" ]; then
    echo "You must define num_samples in your config file"
    exit 1
fi

pwd=`/bin/pwd`

crucible run iperf,uperf\
 --mv-params iperf-mv-params.json,uperf-mv-params.json\
 --bench-ids iperf:21-26,uperf:1-20,uperf:27-32\
 --tags $tags\
 --num-samples=$num_samples --max-sample-failures=2\
 --endpoint k8s,user:kni,host:$ocp_host,\
nodeSelector:client-1-7+21-22+27:$pwd/nodeSelector-worker000.json,\
nodeSelector:client-8-14+30:$pwd/nodeSelector-worker001.json,\
nodeSelector:client-15-20+23-24+25-26+28-29+31-32:$pwd/nodeSelector-worker002.json,\
nodeSelector:server-28:$pwd/nodeSelector-worker000.json,\
nodeSelector:server-23+24+29:$pwd/nodeSelector-worker001.json,\
nodeSelector:server-1-20+21-22+25-26+27+30+31-32:$pwd/nodeSelector-worker002.json,\
userenv:stream8,\
resources:default:$pwd/resource-2req.json,\
resources:server-1-20:$pwd/resource-1req.json.json,\
resources:client-15-20:$pwd/resource-1req.json.json,\
client:1-32,\
server:1-32
