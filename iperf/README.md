# How to use *iperf3* benchmark

Natively, *iperf3* is a client-server application. See *iperf3* manpage. As a *Crucible* iperf3 benchmark, it inherits *Crucible* common features. They are:
 1. Deploy, run, and index results to ES.
 2. Work across endpoint types: k8s and standard linux host
 3. Iterate over a list of tests
 4. Repeat a test case for  multiple samples.
 5. Deploy and correlate tools results i.e. mpstat, vmstat

In addition, *iperf3* benchmark also has specific features:
 1. support several networking topologies: intranode, internode, ingress and egress
 2. *scale out* the number of endpoints
 3. *scale up* the number of iperf pairs per endpoint.
    < more>
## Configure the benchmark
### Prepare a run.sh using the example run.sh by filling in:
 - Networking topology i.e. intranode
 - endpoint details i.e  host names and login info
 - scale_up and scale_out params
 - number of samples.
 - test params in mv-params.json
 - tools params in tools-params.json

mv-params.json examples:

	{
	  "global-options": [
	    {
	      "name": "common-params",
	      "params": [
	        { "arg": "time", "vals": ["10"] },
	        { "arg": "protocol", "vals": ["tcp", "udp"] },
	        { "arg": "ifname", "vals": ["eth0"], "role": "server" }
	      ]
	    }
	  ],
	  "sets": [
	    {
	      "include": "common-params",
	      "params": [
	        { "arg": "length", "vals": [ "16K"] },
	        { "arg": "bitrate", "vals": ["5G"], "role": "client" }
	      ]
	    },
	    {
	      "include": "common-params",
	      "params": [
	        { "arg": "length", "vals": [ "16K"] },
	        { "arg": "bitrate", "vals": ["5G"], "role": "client" },
	        { "arg": "passthru", "vals": ["--reverse"], "role": "client" }
	      ]
	    }
	  ]
	}

Supported test params (in mv-params.json)

 1. **time**        - test duration in seconds
 2. **protocol**  - udp or tcp
 3. **ifname**    - server interface 
 4. **length**     - L4 PDU. see iperf3 manpage 
 5. **bitrate**    - tx rate. See iperf3 manpage. 
 6. **passthru**   - comma separated list of *iperf3*  options. e.g. "--reverse,-i2". There can be no spaces in the list. The native *iperf3* has more command line options not in the above list which may be of interests for specific test scenarios. The user can pass those params as pass-through options. The pass-through params will not be syntax checked by the benchmark, and hence it is the user's responsibility for ensuring their applicability.

### Execute 'bash run.sh'

## Examine test results:
A sample result is as follows

	run-id: 5eaeab54-4581-4f92-b015-e71e9177cf00                                                                                         
	  tags: irq=bal kernel=4.18.0-305.40.2.rt7.113.el8_4.x86_64 mtu=1400 osruntime=chroot pods-per-worker=1 rcos=4tx                     10.84.202203221702-0 scale_out_factor=1 sdn=OVNKubernetes topo=intranode userenv=stream8                                             
	  metrics:                                                                                                                           
	    source: procstat                                                                                                                 
	      types: interrupts-sec                                                                                                          
	    source: iperf                                                                                                                    
	      types: rx-Gbps tx-Gbps rx-lost-per-sec rx-pps                                                                                  
	  iterations:                                                                                                                        
	    common params: bitrate=5G ifname=eth0 length=16K time=10 
	    iteration-id: EC6E517A-E09B-11EC-99F5-A770CD6639B4
	      unique params: protocol=tcp 
	      primary-period name: measurement
	      samples:
	        sample-id: EC78955E-E09B-11EC-B295-A770CD6639B4
	          primary period-id: EC7962C2-E09B-11EC-94A4-A770CD6639B4
	          period range: begin: 1653971775246 end: 1653971785245
	        result: (rx-Gbps) samples: 5.00 mean: 5.00 min: 5.00 max: 5.00 stddev: N
	    iteration-id: EC7D08E6-E09B-11EC-B4A8-A770CD6639B4
	      unique params: protocol=udp 
	      primary-period name: measurement
	      samples:
	        sample-id: EC84BF28-E09B-11EC-8C86-A770CD6639B4
	          primary period-id: EC86195E-E09B-11EC-9373-A770CD6639B4
	          period range: begin: 1653971850877 end: 1653971861876
	        result: (rx-Gbps) samples: 4.94 mean: 4.94 min: 4.94 max: 4.94 stddev: N
	: 0.15
	      
## Common Query examples:
Get summary:

	crucible get result --run 5eaeab54-4581-4f92-b015-e71e9177cf00
Query a specific time:

	crucible get metric --source iperf --period EC7962C2-E09B-11EC-94A4-A770CD6639B4 --type rx-pps --resolution 10
