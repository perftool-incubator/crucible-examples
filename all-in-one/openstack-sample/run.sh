#!/bin/bash

# This tests 2 different benchmarks (uperf, iperf) at the same time,
# targeting an openstack cluster.
#
# This crucible controller must be able to ssh stack@remote_host without password prompt
# This requires at least 3 compute nodes with flavor "tiny" defined and network "mgmt" defined.
# The mgmt network must be able to access the internet and the crucible controller
# The remote_host must be able to ssh with user stack to root@all-compute-nodes
# An image "stream8" must exist in the cluster with cloud-init enabled and podman installed
remote_host=e35-h01-000-r650.rdu2.scalelab.redhat.com
compute_0=compute-r650-0.localdomain
compute_1=compute-r650-1.localdomain
compute_2=compute-r650-2.localdomain

# set the number of samples for your run
samples=1

# userenv to build containers using
userenv="stream9"
vm_image="stream8"
flavor="rhel-vm-flavor"

crucible run iperf,uperf\
 --mv-params iperf-mv-params.json,uperf-mv-params.json\
 --bench-ids iperf:2,uperf:1\
 --num-samples=$samples --max-sample-failures=3\
 --endpoint osp,host:${remote_host},user:stack,\
flavor:default:$flavor,\
availability-zone:client-1:nova:$compute_0,\
availability-zone:client-2:nova:$compute_1,\
availability-zone:server-1-2:nova:$compute_2,\
client:1-2,\
server:1-2,\
osruntime:podman,\
userenv:$userenv,\
vm-image:$vm_image
