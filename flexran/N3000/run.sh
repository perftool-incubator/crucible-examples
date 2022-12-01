#!/bin/bash

# ocp admin node
k8shost1=perf154.perf.lab.eng.bos.redhat.com
bmlhosta=perf154.perf.lab.eng.bos.redhat.com

userenv=stream8
securityContext_file="`/bin/pwd`/securityContext.json"
volumeMounts_file="`/bin/pwd`/volumeMounts.json"
volumes_file="`/bin/pwd`/volumes.json"

resources_file="`/bin/pwd`/resources.json"       # for h/w FEC, use resources-fec.json
# resources_file="`/bin/pwd`/resources-fec.json"
#annotations_file="`/bin/pwd`/annotations.json"  # for XRAN, use xran-annotations.json
annotations_file="`/bin/pwd`/xran-annotations.json"
#mv_file="`/bin/pwd`/mv-params.json"             # For both timer and XRAN tests, see mv-params-multi.json
mv_file="`/bin/pwd`/mv-params-run-0-0-5-all-test.json" 
                                                # Be sure to create those hn*cfg as they reduced-load tests
#mv_file="`/bin/pwd`/mv-params-multi.json"
# set the number of samples for your run
samples=1

endpoint_opt="--endpoint k8s,host:$k8shost1,user:root,client:1-1"
endpoint_opt+=",userenv:stream8,cpu-partitioning:default:1,resources:client-1:$resources_file,annotations:client-1:$annotations_file,securityContext:client-1:$securityContext_file,hugepage:1,volumeMounts:client-1:$volumeMounts_file,volumes:client-1:$volumes_file"

endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,server:1-1,userenv:$userenv,osruntime:chroot"
endpoint_opt+=",host-mount:/opt/flexran,host-mount:/opt/intel,host-mount:/opt/dpdk-20.11"

crucible run flexran  --mv-params ${mv_file} --num-samples ${samples} --max-sample-failures ${samples} $endpoint_opt

