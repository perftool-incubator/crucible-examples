#!/bin/bash

# trafficgen host
remhost1=perfxxx.perf.lab.eng.bos.redhat.com

# ocp admin node
k8shost1=perfxxx.perf.lab.eng.bos.redhat.com

resources_file="`/bin/pwd`/resources.json"
annotations_file="`/bin/pwd`/annotations.json"
securityContext_file="`/bin/pwd`/securityContext.json"

# set the number of samples for your run
samples=1

crucible run trafficgen \
  --mv-params mv-params.json \
  --num-samples ${samples} \
  --max-sample-failures ${samples} \
  --test-order r \
  --endpoint remotehost,host:$remhost1,user:root,client:1,userenv:centos8,cpu-partitioning:client-1:1 \
  --endpoint k8s,host:$k8shost1,user:root,server:1,userenv:centos8,resources:server-1:$resources_file,annotations:server-1:$annotations_file,securityContext:server-1:$securityContext_file,hugepage:1,cpu-partitioning:server-1:1,runtimeClassName:performance-performance

