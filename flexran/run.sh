#!/bin/bash

# ocp admin node
k8shost1=xxx.yyy.zzz

resources_file="`/bin/pwd`/resources.json"
annotations_file="`/bin/pwd`/annotations.json"
securityContext_file="`/bin/pwd`/securityContext.json"
volumeMounts_file="`/bin/pwd`/volumeMounts.json"
volumes_file="`/bin/pwd`/volumes.json"

# set the number of samples for your run
samples=1

crucible run flexran \
  --mv-params mv-params.json \
  --num-samples ${samples} \
  --max-sample-failures ${samples} \
  --test-order r \
  --endpoint k8s,host:$k8shost1,user:kni,client:1,userenv:stream,cpu-partitioning:default:1,resources:client-1:$resources_file,annotations:client-1:$annotations_file,securityContext:client-1:$securityContext_file,hugepage:1,volumeMounts:client-1:$volumeMounts_file,volumes:client-1:$volumes_file

