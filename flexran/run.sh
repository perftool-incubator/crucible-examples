#!/bin/bash

# ocp admin node
k8shost1=xxx.yyy.zzz

resources_file="`/bin/pwd`/resources.json"
# for h/w FEC, see resources-fec.json
#resources_file="`/bin/pwd`/resources-fec.json"
annotations_file="`/bin/pwd`/annotations.json"
# for XRANC, see /xran-annotations.json
#annotations_file="`/bin/pwd`/xran-annotations.json"
securityContext_file="`/bin/pwd`/securityContext.json"
volumeMounts_file="`/bin/pwd`/volumeMounts.json"
volumes_file="`/bin/pwd`/volumes.json"
mv_file="`/bin/pwd`/mv-params.json"
# For timer and XRAN test, see /mv-params-multi.json
#mv_file="`/bin/pwd`/mv-params-multi.json"

# set the number of samples for your run
samples=1

crucible run flexran \
  --mv-params ${mv_file} \
  --num-samples ${samples} \
  --max-sample-failures ${samples} \
  --endpoint k8s,host:$k8shost1,user:root,client:1,userenv:stream8,cpu-partitioning:default:1,resources:client-1:$resources_file,annotations:client-1:$annotations_file,securityContext:client-1:$securityContext_file,hugepage:1,volumeMounts:client-1:$volumeMounts_file,volumes:client-1:$volumes_file

