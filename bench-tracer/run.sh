#!/bin/bash

targets="k8s"
#targets="rhel"
#targets="k8s rhel"

endpoint_arg=""

csid=1

for target in ${targets}; do
    case "${target}" in
	"k8s")
	    remote_host=xxx.yyy.zzz
	    endpoint_arg+=" --endpoint k8s,host:${remote_host},user:root,client:${csid},cpu-partitioning:client-${csid}:1,volumeMounts:client-${csid}:`/bin/pwd`/volumeMounts.json,volumes:client-${csid}:`/bin/pwd`/volumes.json,resources:client-${csid}:`/bin/pwd`/resource.json,nodeSelector:client-${csid}:`/bin/pwd`/nodeSelector.json,securityContext:client-${csid}:`/bin/pwd`/securityContext.json,masters-tool-collect:0"
	    ;;
	"rhel")
	    remote_host=xxx.yyy.zzz
	    endpoint_arg+=" --endpoint remotehost,host:${remote_host},user:root,client:${csid},cpu-partitioning:client-${csid}:1"
	    ;;
	*)
	    echo "ERROR: unknown target [${target}]"
	    exit 1
	    ;;
    esac

    (( csid += 1 ))
done

echo "endpoint_arg=[${endpoint_arg}]"

crucible run tracer \
	 --num-samples 1 \
	 --mv-params mv-params.json \
	 ${endpoint_arg}
