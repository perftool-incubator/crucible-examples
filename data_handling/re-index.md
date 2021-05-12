# Re-Indexing results

## delete the run first
` crucible  rm delete-run --run <run_id>`


## Now add it back
Occasionally a run will need to be re-uploaded to the local elastic search instance.The way to do this:
`crucible posprocess <run_dir>`


With a specific examples: `crucible postprocess uperf-2021-04-27_15:02:24--sdn:OVNKubernetes,mtu:8900,rcos:47.83.202103191543-0,kernel:4.18.0-240.15.1.el8_3.x86_64,irq:bal,userenv:centos8,osruntime:pod,topo:internode,pods-per-worke
r:64,scale_out_factor:1`


