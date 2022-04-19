#!/bin/bash
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=bash
# -*- mode: sh; indent-tabs-mode: nil; sh-basic-offset: 4 -*-

# Variables which apply to all test environments
################################################
topo="interhost" # internode = client/server pods on different nodes in ocp/k8s cluster
                 # intranode = client/server pods on same worker node in ocp/k8s cluster
                 # ingress = client outside (BML host or VM), server inside ocp/k8s cluster
                 # interhost = between two BML hosts/VMs, not k8s/ocp
scale_out_factor=1   # Determines the number of hosts/nodes that will get used
                 # For internode: total workers = 2 * $scale_out_factor, and each worker-pair
                 #  consists of first worker running uperf-client pods and the second uperf-server pods.
                 # For ingress/egress: (OCP) total workers = 1 * $scale_out_factor, where uperf client and server
                 #  pods are on the same worker (no external traffic)
userenv=stream # can be centos7, centos8, stream, rhubi8, debian, opensuse
osruntime=chroot # can be pod or kata for OCP (not yet verified for SRIOV), chroot for remotehost
scale_up_factor="1" # Number of client-server pairs per host/node/node-pair
interhost_dir=forward # forward, reverse, bidirec
samples=3 # Ideally use at least 3 samples for each benchmark iteration.
max_failures=3 # After this many failed samples the run will quit
#user_tags= # Comma-separated list of something=value, these help you identify this run as different
            #  from other runs, for example:  "cloud-reservation:48,HT:off,CVE:off"
            # Note that many tags are auto-generated below
mv_params_file="uperf-mv-params.json" # All benchmark-iterations are built from this file

# Variables for ocp/k8s environments
####################################
num_cpus=40  # A few fewer than the number of *Allocatable* cpus on each of the workers.
             # as reported by oc describe node/node-name
             # This affects cpu request (and limit for static qos)
             # TODO: this should be automatically calculated.
pod_qos=burstable # static = guaranteed pod, burstable = default pos qos
ocphost=admin-host.domain # must be able to ssh without password prompt
k8susr=kni # Might be "root" or "kni" for some installations
  # Use for SRIOV or comment out for default network
#annotations=`/bin/pwd`/sriov-annotations.json # Use for SRIOV or comment out for default network
                                                # Must populate this file with correct annotation
  # Use to disable or enable IRQs, comment out if you are not using Performance Addon Operator
#annotations=`/bin/pwd`/no-irq-annotations.json
#runtimeClassNameOpt=",runtimeClassName:performance-performance"
irq="bal" # bal by default or rrHost or <something-else> depending on what manual mods made
          # This is completely manual and needs to be confirmed by the user!

# Variables if one or more remotehost
# endpoints are used (topo=ingress|egress|interhost)
#####################################
bmlhosta=hosta # Used for topo=ingress|egress|interhost
bmlhostb=hostb # Used for interhost


resource_file="`/bin/pwd`/resource.json"
    
# Create a resource JSON to size the pods
function gen_resource_file() {
    local cpu=$1
    if [ "$pod_qos" == "static" ]; then
        # use whole numbers for CPU
        echo '"resources": {'     >$resource_file
        echo '    "requests": {' >>$resource_file
        # TODO: horribly broken! Need to round down to whole number!
        echo '        "cpu": "2",' >>$resource_file
        echo '        "memory": "2048Mi"' >>$resource_file
        echo '    },' >>$resource_file
        echo '    "limits": {' >>$resource_file
        # TODO: horribly broken! Need to round down to whole number!
        echo '        "cpu": "2",' >>$resource_file
        echo '        "memory": "2048Mi"' >>$resource_file
        echo '    }' >>$resource_file
        echo '}' >>$resource_file
    else # non-guaranteed pod
        echo '"resources": {'     >$resource_file
        echo '    "requests": {' >>$resource_file
        echo '        "cpu": "'$cpu'"' >>$resource_file
        echo '    }' >>$resource_file
        echo '}' >>$resource_file
    fi
}


# check for dependencies
bins="jq bc ssh sed crucible"
missing_bins=""
for bin in $bins; do
    which $bin >/dev/null 2>&1 || missing_bins="$missing_bins $bin"
done
if [ ! -z "$missing_bins" ]; then
    echo "ERROR: these required bins are needed; please install before running this script:"
    echo $missing_bins
    exit 1
fi
    

# What is below is code to generate the appropriate crucible command to tun your test.
# There is a ton of duplicated code that needs to be consolidated.

if [ ! -z "$annotations" ]; then
    if [ -f "$annotations" ]; then
        echo "Using annotations: $annotations"
        anno_opt=",annotations:$annotations"
    else
        echo "Annoations file missing: $annotations"
        exit
    fi
else
    anno_opt=""
fi

for num_pods in $scale_up_factor; do
    num_clients=`echo "$num_pods * $scale_out_factor" | bc`
    num_servers=$num_clients
    if [ "$topo" != "interhost" ]; then # Any test involving ocp/k8s
        ssh $k8susr@$ocphost "kubectl get nodes -o json" >nodes.json
        workers=(`jq -r '.items[] | .metadata.labels | select(."node-role.kubernetes.io/worker" != null) | ."kubernetes.io/hostname"' nodes.json | tr '\n' ' '`)
        first_worker=`echo ${workers[0]}`
        if [ -z "$first_worker" ]; then
            "First worker not defined, exiting"
            exit 1
        fi
        if [ "$topo" == "internode" ]; then
            nodes_per_client_server=2
        else
            nodes_per_client_server=1
        fi
        min_worker_nodes=`echo "$scale_out_factor * $nodes_per_client_server" | bc`
        if [ ${#workers[@]} -lt $min_worker_nodes ]; then
            echo "Need at least $min_worker_nodes to run tests, and this cluster only has ${#workers[@]}"
            exit 1
        fi
        per_pod_cpu=`echo "1000 * $num_cpus / $num_pods" | bc`m
        gen_resource_file $per_pod_cpu
        ssh $k8susr@$ocphost "kubectl get nodes/$first_worker -o json" >worker.json
        kernel=`jq -r .status.nodeInfo.kernelVersion worker.json`
        rcos=`jq -r .status.nodeInfo.osImage  worker.json | awk -F"CoreOS " '{print $2}' | awk '{print $1}'`
        ssh $k8susr@$ocphost "kubectl get network -o json" >network.json
        network_type=`jq -r .items[0].status.networkType network.json`
        network_mtu=`jq -r .items[0].status.clusterNetworkMTU network.json`
            ns_file[0]=""
            ns_file[1]=""
            # Create a nodeSelector JSON to place pods
            for i in `seq 1 $scale_out_factor`; do
                for j in 0 $(($nodes_per_client_server-1)); do
                    idx=`echo "($i-1)*2+$j" | bc`
                    this_worker=${workers[$idx]}
                    ns_file[$j]=`/bin/pwd`/nodeSelector-$this_worker.json
                    echo '"nodeSelector": {' >${ns_file[$j]}
                        echo '    "kubernetes.io/hostname": "'$this_worker'"' >>${ns_file[$j]}
                    echo '}' >>${ns_file[$j]}
                done
                # Populate the node_selector option
                for k in `seq 1 $num_pods`; do
                    if [ "$topo" == "internode" -o "$topo" == "egress" ]; then
                        client_idx=0
                        server_idx=1
                    fi
                    if [ "$topo" == "intranode" -o "$topo" == "ingress" ]; then
                        client_idx=0
                        server_idx=0
                    fi
                    cs_num=`echo "$num_pods * ($i-1) + $k" | bc`
                    # Add clients
                    if [ "$topo" == "internode" -o "$topo" == "intranode" -o "$topo" == "egress" ]; then
                        node_selector="$node_selector,`printf "nodeSelector:client-$cs_num:\${ns_file[$client_idx]}"`"
                    fi
                    # Add servers
                    if [ "$topo" == "internode" -o "$topo" == "intranode" -o "$topo" == "ingress" ]; then
                        node_selector="$node_selector,`printf "nodeSelector:server-$cs_num:\${ns_file[$server_idx]}"`"
                    fi
                done
                node_selector=`echo $node_selector | sed -e s/^,//`
            done
        endpoint_opt="--endpoint k8s,user:$k8susr,host:$ocphost"
        endpoint_opt+=",${node_selector}"
        endpoint_opt+=",userenv:$userenv"
        endpoint_opt+=",resources:default:$resource_file"
        endpoint_opt+=",osruntime:${osruntime}"
        endpoint_opt+="$anno_opt"
        endpoint_opt+="${runtimeClassNameOpt}"
    else
        echo "interhost"
        endpoint_opt=""
        network_type=flat
        network_mtu=1500 # TODO: get actual mtu
        rcos=na
        kernel=`ssh $bmlhosta uname -r`
    fi

    if [ "$topo" == "internode" -o "$topo" == "intranode" ]; then
        endpoint_opt+=",client:1-$num_clients,server:1-$num_servers"
    elif [ "$topo" == "ingress" ]; then
        endpoint_opt+=",server:1-$num_servers"
        endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,client:1-$num_pods,userenv:$userenv "
    elif [ "$topo" == "egress" ]; then
        endpoint_opt+=",client:1-$num_servers"
        endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,server:1-$num_pods,userenv:$userenv "
    elif [ "$topo" == "interhost" ]; then
        # TODO: make work for $scale_out_factor > 1
        if [ "$interhost_dir" == "forward" ]; then
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,client:1-$num_pods,userenv:$userenv,osruntime:$osruntime"
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhostb,server:1-$num_pods,userenv:$userenv,osruntime:$osruntime"
        elif [ "$interhost_dir" == "reverse" ]; then
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,server:1-$num_pods,userenv:$userenv,osruntime:$osruntime"
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhostb,client:1-$num_pods,userenv:$userenv,osruntime:$osruntime"
        elif [ "$interhost_dir" == "bidirec" ]; then
            odd_ids=`seq 1 2 $(($num_pods*2)) | tr '\n' '+'  | sed -e s/+$//`
            even_ids=`seq 2 2 $(($num_pods*2)) | tr '\n' '+'  | sed -e s/+$//`
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhosta,client:$odd_ids,server:$even_ids,userenv:$userenv,osruntime:$osruntime"
            endpoint_opt+=" --endpoint remotehost,user:root,host:$bmlhostb,server:$odd_ids,client:$even_ids,userenv:$userenv,osruntime:$osruntime"
        fi
    fi

    tags="sdn:$network_type,mtu:$network_mtu,rcos:$rcos,kernel:$kernel,irq:$irq,userenv:$userenv,osruntime:$osruntime"
    tags+=",topo:$topo,pods-per-worker:$num_pods,scale_out_factor:$scale_out_factor"
    if [ "$topo" == "interhost" ]; then
        tags+=",dir:$interhost_dir"
    fi
    if [ "$topo" == "internode" -a "$topo" == "intranode" ]; then
        tags+=",pod_qos:$pod_qos"
    fi
    if [ ! -z "$other_tags" ]; then
        tags+="other_tags"
    fi
    crucible run uperf --tags $tags --mv-params $mv_params_file --num-samples=$samples --max-sample-failures=$max_failures $endpoint_opt
done
