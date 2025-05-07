#!/bin/bash

# ocp admin node
k8shost=perf154.perf.lab.eng.bos.redhat.com
bmlhosta=perf154.perf.lab.eng.bos.redhat.com

userenv=stream8-flexran
securityContext_file="`/bin/pwd`/securityContext.json"
volumeMounts_file="`/bin/pwd`/volumeMounts.json"
volumes_file="`/bin/pwd`/volumes.json"

resources_file="`/bin/pwd`/resources-fec-acc100.json"
annotations_file="`/bin/pwd`/annotations.json"  # for XRAN, use xran-annotations.json
mv_file="`/bin/pwd`/mv-params.json" 

# set the number of samples for your run
samples=1

endpoint_opt="--endpoint k8s,host:$k8shost,user:root,client:1-1"
endpoint_opt+=",userenv:$userenv,cpu-partitioning:default:1,resources:client-1:$resources_file,annotations:client-1:$annotations_file,securityContext:client-1:$securityContext_file,hugepage:1,volumeMounts:client-1:$volumeMounts_file,volumes:client-1:$volumes_file"

endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,server:1-1,userenv:$userenv,osruntime:chroot"
#endpoint_opt+=",host-mount:/opt/flexran,host-mount:/opt/intel,host-mount:/opt/dpdk-20.11"

crucible run flexran --no-tools   --mv-params ${mv_file} --num-samples ${samples} --max-sample-failures ${samples} $endpoint_opt

