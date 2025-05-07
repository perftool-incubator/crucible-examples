# FlexRAN Benchmark

## Intro
Intel FlexRAN is a 4G and 5G baseband PHY/L1 Reference platform. See [https://github.com/intel/FlexRAN](https://github.com/intel/FlexRAN).

In the current form, an Intel FlexRAN release comprises of the L1 source code, the adaptation s/w to
interface to the hardware-assisted FEC PCI cards i.e N3000 or ACC100 cards, and the Testmac (the L2 test harness).

## Limitations
Comparing to other crucible benchmarks i.e. uperf, fio etc, the crucible FlexRAN benchmark in the current state has several
limitations and/or extra prerequisites.

- FlexRAN S/W must be prebuilt outside of crucible workshop
- Support OCP only (No server support)
- Container must mount FlexRAN S/W from worker node.
- Indexing to ES only a few metrics. Full FlexRAN results available in the log files.

### Setup The Testbed

1. Building FlexRAN software

	As mentioned above, a FlexRAN release comes with S/W in source. One must have a mean (Intel contact) to obtain a FlexRAN release.
    See https://github.com/HughNhan/FlexRAN-utils for more details.

2. Setup the OCP cluster to host FlexRAN

	Currently, crucible FlexRAN benchmark only supports k8s endpoint type. This purely is a requirement call.

	FlexRAN can run w/o a h/w assisted FEC device.
    See https://github.com/perftool-incubator/bench-flexran/tree/main/script-dir for the complete set of scripts 
    to provision the work node and SNO, and the RU to run FLEXRAN timer and XRAN tests.

## How to run FlexRAN benchmark

### Running Default Tests.
	$ bash run.sh

Testmac run CLI format is as follows:
	
    $ run [test_type: 0-DL 1-UL 2-FD] [Numerology] [Bandwidth] Test_num]

A 'bash run.sh' will kick off 3 iterations:

1. runall 0 0 5         - The equivalent to run 0 0 5 [all-test]
2. run 2 0 5 1001       - run test 1001
3. run a list of tests specified by "/opt/flexran/tests/nr5g/fd/testmac_fd_mu0_5mhz.cfg"

### Running Custom Tests.
Let us first explore the configuration files.

#### annotations.json
For configuring low-latency app. To support XRAN, we need a pair of SRIOV VF's. See *xran-annotations.json*

#### resource.json
FlexRAN L1 has 5 threadds. and Testmac has 4. Currently the helper script expects a minimum of 9 cores and automatically pin the first 9 cores to those 9 threads. The script will error out if detecting less than 9 cores being allocated to the pod. A H/W FEC device ACC100 is required, but in development we may run some tests (See *fec-mode* in mv-params.json) on testbed that does not have an ACC100. See *resources-fec.json* when testbed has H/W FEC.

#### securityContext.json
No customization.

#### volumes.json and volumeMounts.json
These two files set up hugepage and host mount. No customization

#### tool-params.json
Can be changed to include more or less tools

#### mv-params.json
Outside Crucible, one can initiate tests from the Testmac console (manual mode)

	TESTMAC > run [test_type: 0-DL 1-UL 2-FD] [Numerology] [Bandwidth] [optional: test_num]

For example

	TESTMAC> run 2 0 5 1001
    
Also outside Crucible, one can invoke Testmac with the TESTFILE env specifying the test config file (script mode). For example:
    
    $ TESTFILE=/opt/flexran/tests/nr5g/fd/testmac_fd_mu0_5mhz.cfg l2.sh

In above command, l2.sh is the front-end of Testmac, and 'testmac_fd_mu0_5mhz.cfg' contains a list of tests to run.

#### mv-params.json, mv-params-multi.json
Support both the manual mode and the script mode for crucible FlexRAN

To synthesize manual-mode:

            "params": [
                { "arg": "fec-mode", "vals": ["hw"], "role": "client" },
                { "arg": "usr1", "vals": ["runall"], "role": "client" },
                { "arg": "usr2", "vals": ["2"], "role": "client" },
                { "arg": "usr3", "vals": ["0"], "role": "client" },
                { "arg": "usr4", "vals": ["5"], "role": "client" },
		{ "arg": "usr5", "vals": ["1001"], "role": "client" },
                { "arg": "log-test", "vals": ["FD_1001"], "role": "client" }
            ]

To synthesize a script-mode run:

            "params": [
                { "arg": "duration", "vals": ["60"], "role": "client" },
                { "arg": "fec-mode", "vals": ["hw"], "role": "client" },
                { "arg": "test-file", "vals": ["/opt/flexran/tests/nr5g/fd/testmac_fd_mu0_5mhz.cfg"], "role": "client" },
                { "arg": "log-test", "vals": ["FD_12001"], "role": "client" }
            ]

- vals is an array. For each value in the array, crucible orchestratrates one test iteration.
- duration: is optional. It specifies the maximum duration the test may take. It helps the benchmark to timeout more precisely. This param is applicable per individual test.
- fec-mode: valid values are "hw" and "sw" - As mentioned previously, flexran can run with or w/o FEC hardware. When fec-mode value is "sw", the L1 invokes its s/w-emulated method to perform the FEC function. W/o a working h/w FEC device, be sure to only use "sw".

- 'useN' and 'test-file' support manual-mode and script-mode accordingly.

- log-test: when we invoke 'runall' or script mode, "TESTFIEL=xxx ./l2.sh", the benchmark runs multiple tests. Currently the helper script only indexes one metric of one test. The 'log-test' variable specifies that test. The valid values for log-test are the test names i.e FD_1001.
    
For XRAN, it needs several additional params:

            "params": [
                { "arg": "xran-devices", "vals": [ "PCIDEVICE_OPENSHIFT_IO_FLEXRAN_FRONTHAUL" ], "role": "client" },
                { "arg": "xran-devices", "vals": [ "ens8f1" ], "role": "server" },
                { "arg": "test-file", "vals": ["/opt/flexran/bin/nr5g/gnb/l1/orancfg/sub3_mu0_20mhz_4x4/gnb/testmac_clxsp_mu0_20mhz_hton_oru.cfg"], "role": "client" },
                { "arg": "cc-num", "vals": [ "12" ], "role": "server" },
                { "arg": "oru-dir",   "vals": ["/opt/flexran/bin/nr5g/gnb/l1/orancfg/sub3_mu0_20mhz_4x4/oru"], "role": "server" },
                { "arg": "log-test", "vals": ["FD_1001"], "role": "client" }
            ]
- xran-devices: on client side, contains the SRIOV-plugin annotates. See SriovNetworkNodePolicy. On server/RHEL/RU side, it contains the front-haul NIC nane.
- test-file: the XRAN test spec
- cc-num: this params is for the RU/server. It contains the number of cell cites corresponding to the test spec'ed by test-file
- oru-dir: this params is for the RU/server, It points the RU config file for the test spec;ed by test-file
 
# Crucible Run Results


    run-id: EE6A7104-1D5D-11EC-B0D7-66F060E020CC
      tags:
      metrics:
        source: procstat
          types: interrupts-sec
        source: mpstat
          types: Busy-CPU NonBusy-CPU
        source: sar-net
          types: packets-sec L2-Gbps errors-sec
        source: iostat
          types: avg-queue-length avg-req-size-kB avg-service-time-ms kB-sec operations-sec percent-utilization operations-merged-sec percent-merged
        source: sar-scheduler
          types: Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length IO-Blocked-Tasks %-Time-Tasks-CPU-Starved-last_interval
        source: sar-mem
          types: Page-faults-sec KB-Paged-out-sec Pages-freed-sec %-Time-Non-Idle-Tasks-Stalled-on-Memory-300s %-Time-Tasks-Waiting-on-Memory-010s %-Time-Tasks-Waiting-on-Memory-300s %-Time-Taast_interval kswapd-scanned-pages-sec
        source: flexran
          types: DL UL
        source: sar-tasks
          types: Context-switches-sec Processes-created-sec
        source: sar-io
          types: %-Time-Tasks-Lost-Waiting-on-IO-300s %-Time-Tasks-Stalled-Waiting-on-IO-300s
      iterations:
        iteration-id: 7C71B65E-1D60-11EC-AFB5-18FE60E020CC
          params: fec-mode=hw log-test=FD_1001 usr1=runall usr2=2 usr3=0 usr4=5
          primary-period name: measurement
          samples:
            sample-id: 7C7540B2-1D60-11EC-AFB5-18FE60E020CC
              primary period-id: 7C75FDFE-1D60-11EC-AFB5-18FE60E020CC
              period range: begin: 1632505337758 end: 1632505970825
            result: (DL) samples: 54.11 mean: 54.11 min: 54.11 max: 54.11 stddev: NaN stddevpct: NaN
        iteration-id: 7C7DCAE8-1D60-11EC-AFB5-18FE60E020CC
          params: fec-mode=hw log-test=FD_1001 usr1=run usr2=2 usr3=0 usr4=5 usr5=1001
          primary-period name: measurement
          samples:
            sample-id: 7C815262-1D60-11EC-AFB5-18FE60E020CC
              primary period-id: 7C81DBC4-1D60-11EC-AFB5-18FE60E020CC
              period range: begin: 1632505104585 end: 1632505161612
            result: (DL) samples: 53.33 mean: 53.33 min: 53.33 max: 53.33 stddev: NaN stddevpct: NaN
        iteration-id: 7C886692-1D60-11EC-AFB5-18FE60E020CC
          params: fec-mode=hw log-test=FD_12001 test-file=/opt/flexran/tests/nr5g/fd/testmac_fd_mu0_5mhz.cfg
          primary-period name: measurement
          samples:
            sample-id: 7C89D202-1D60-11EC-AFB5-18FE60E020CC
              primary period-id: 7C8A524A-1D60-11EC-AFB5-18FE60E020CC
              period range: begin: 1632505210654 end: 1632505288683
            result: (DL) samples: 66.63 mean: 66.63 min: 66.63 max: 66.63 stddev: NaN stddevpct: Na



# Raw FlexRAN Results:
The raw results are found in similar file path as:

	/var/lib/crucible/run/latest/run/iterations/iteration-1/sample-1/client/
        
This directory contains result files generated by Intel FlexRAN itself, and files generated by crucible FlexRAN benchmark

The major crucible FlexRAN files are:

 - post-process-output.txt   - logs of result processing

 - flexran-client.log   - logs of FlexRAN container

The major Intel FlexRAN result files are:

 - l1_mlog_stats.txt  - contains the most important results of all
 - Results.txt  - a listing of the tests ran
 - l1m*			- l1 results
 - PhyStats*    - Phy results from L1 and Testmac


# Querying Crucible ES for Past Results


 	$ crucible get metric --source flexran --type <UL/DL> --period <> --begin <> --end <> --breakout type




-- EOF ---


