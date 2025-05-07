#!/bin/bash

# ocp admin node
k8shost=perf154.perf.lab.eng.bos.redhat.com
bmlhosta=perf154.perf.lab.eng.bos.redhat.com
k8susr=root

userenv=stream8-flexran
securityContext_file="`/bin/pwd`/securityContext.json"
volumeMounts_file="`/bin/pwd`/volumeMounts.json"
volumes_file="`/bin/pwd`/volumes.json"

resources_file="`/bin/pwd`/resources.json"       # for h/w FEC, use resources-fec.json
annotations_file="`/bin/pwd`/xran-annotations.json"
mv_file="`/bin/pwd`/mv-params.json"
# set the number of samples for your run
samples=1
#
# If we are using XRAN, the SRIOV networks can take a long time to come back from the previous namespace deletion.
# Hence, bounce the networks.
#
if [ ! -z "$annotations_file" ]; then
    if [ $(basename -- $annotations_file) == "xran-annotations.json" ]; then
       #sriov_vlan=`do_ssh $k8usr@$k8shost "kubectl get network-attachment-definitions  -n crucible-rickshaw -o wide" | grep sriov-vlan10  awk '{print $1}'`
       #if [ "$sriov_vlan" == "" ]; then
          # Bounce the network-attachment-definition,
          echo "Using XRAN annotations: $annotations_file - bounce SriovNetwork"
          ssh $k8susr@$k8shost "kubectl create namespace crucible-rickshaw" 2> /dev/null
          # Get the current SriovNetwork manifest so we can bounce it.
          ssh $k8susr@$k8shost "kubectl get SriovNetwork  -n openshift-sriov-network-operator -o json" >  sriov-network.json
          kind=`jq -r .items[0].kind sriov-network.json 2> /dev/null`
          if [ "$kind"  != "null" ]; then
            cat "sriov-network.json" | ssh $k8susr@$k8shost "kubectl delete -f -"
            cat "sriov-network.json" | ssh $k8susr@$k8shost "kubectl apply -f -"
          fi
       #fi
       #ssh $k8susr@$k8shost "kubectl get network-attachment-definitions  -n crucible-rickshaw -o json"
    fi
fi

endpoint_opt="--endpoint k8s,host:$k8shost,user:root,client:1-1"
endpoint_opt+=",userenv:$userenv,cpu-partitioning:default:1,resources:client-1:$resources_file,annotations:client-1:$annotations_file,securityContext:client-1:$securityContext_file,hugepage:1,volumeMounts:client-1:$volumeMounts_file,volumes:client-1:$volumes_file"

endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,server:1-1,userenv:$userenv,osruntime:chroot"

crucible run flexran --no-tools --mv-params ${mv_file} --num-samples ${samples} --max-sample-failures ${samples} $endpoint_opt

