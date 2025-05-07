#!/bin/bash

# This tests 2 different benchmarks (uperf, iperf) at the same time,
# targeting an openstack cluster.
#
# This crucible controller must be able to ssh stack@remote_host without password prompt
# This requires at least 3 compute nodes with flavor "tiny" defined and network "mgmt" defined.
# The mgmt network must be able to access the internet and the crucible controller
# The remote_host must be able to ssh with user stack to root@all-compute-nodes
# An image "stream8" must exist in the cluster with cloud-init enabled and podman installed
remote_host=#your-undercloud-host
compute_0=#your-first-compute
compute_1=#your-second-compute
compute_2=#your-third-compute

# set the number of samples for your run
samples=3

# userenv to build containers using
userenv="stream9"
vm_image="stream8"

crucible run iperf,uperf\
 --mv-params iperf-mv-params.json,uperf-mv-params.json\
 --bench-ids iperf:11-16,uperf:1-10,uperf:17-20\
 --num-samples=$samples --max-sample-failures=3\
 --endpoint osp,host:${remote_host},user:stack,\
flavor:default:tiny,\
flavor:server-21-26:tiny,\
flavor:client-21-26:tiny,\
availability-zone:client-1-5+11+13+15+17+18:nova:$compute_0.localdomain,\
availability-zone:client-6-10+12+14:nova:$compute_1.localdomain,\
availability-zone:client-16+19+20:nova:$compute_2.localdomain,\
availability-zone:server-1-18:nova:$compute_2.localdomain,\
availability-zone:server-19:nova:$compute_0.localdomain,\
availability-zone:server-20:nova:$compute_1.localdomain,\
client:1-20,server:1-20,osruntime:podman,userenv:$userenv,vm-image:$vm_image
