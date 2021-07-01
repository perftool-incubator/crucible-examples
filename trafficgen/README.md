# Trafficgen

## Configuring to run the benchmark

Included are the files required to run crucible.  They are:

### mv-params.json
At a minimum, set your "common-params" in the
"global-options" section. These params are required for trafficgen client and
server roles to run TRex benchmark.
You can also set additional params sets with multiple permutations of params
to be tested.

### resources.json
This file is only necessary if you are using the k8s endpoint.
For k8s, we expect that the static CPU policy is available, and you should set
the cpu request and limit to the same number, this number being a positive
integer.
Memory request and limit should also have a matching value (like 2048M).

###  annotations.json
In this file you specify the k8s network to be used and advanced options like
disabling IRQs on the cpus associated to the adapater.

### securityContext.json
A security context defines privilege and access control settings for a Pod or
Container. This is required for running trafficgen on k8s endpoint.

### run.sh
This file shows how a 'crucible run' command is used to run trafficgen on a k8s
cluster.  If you want to run trafficgen on a regular host, you will need to use
the `remotehost` endpoint.

## Running the trafficgen benchmark with crucible
To run trafficgen with crucible, execute the `run.sh` script:
```
./run.sh
```
At the end of the run, you should get a result like:
```
Checking for redis...appears to be running
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running

run-id: 32F5BD76-DA72-11EB-977F-A65A0D9F27D1
  tags:
  metrics:
    source: procstat
      types: interrupts-sec
    source: trafficgen
      types: l1-rx-bps l1-tx-bps l2-rx-bps l2-tx-bps lost-rx-pps max-roundtrip-usec mean-roundtrip-usec rx-pps tx-pps trial-result
    source: mpstat
      types: Busy-CPU NonBusy-CPU
    source: sar-net
      types: L2-Gbps packets-sec errors-sec
    source: sar-scheduler
      types: Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length IO-Blocked-Tasks
    source: sar-mem
      types: Page-faults-sec KB-Paged-out-sec Pages-freed-sec KB-Paged-in-sec
    source: sar-tasks
      types: Context-switches-sec Processes-created-sec
  iterations:
    iteration-id: 65561958-DA74-11EB-883E-1E6B0D9F27D1
      params: active-devices=0000:5e:00.0,0000:5e:00.1,0000:3b:00.0,0000:3b:00.1,0000:86:00.0,0000:86:00.1,0000:af:00.0,0000:af:00.1 devices=VAR:PCIDEVICE_OPENSHIFT_IO_COLUMBIAVILLEAPOD,VAR:PCIDEVICE_OPENSHIFT_IO_COLUMBIAVILLEBPOD devices=0000:5e:00.0,0000:5e:00.1,0000:3b:00.0,0000:3b:00.1,0000:86:00.0,0000:86:00.1,0000:af:00.0,0000:af:00.1 frame-size=64 num-flows=1024 one-shot=0 rate=100 rate-tolerance-failure=fail rate-unit=% send-teaching-measurement=ON send-teaching-warmup=ON testpmd-descriptors=4096 testpmd-forward-mode=io testpmd-mtu=9000 testpmd-queues=1 testpmd-smt=on traffic-direction=bidirectional use-dst-mac-flows=1 use-src-mac-flows=1 validation-runtime=60 warmup-trial=OFF
      primary-period name: measurement
      samples:
        sample-id: 65640540-DA74-11EB-883E-1E6B0D9F27D1
          primary period-id: 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1
          period range: begin: 1625147752047 end: 1625147814267
        result: (rx-pps) samples: 57620000.00 mean: 57620000.00 min: 57620000.00 max: 57620000.00 stddev: NaN stddevpct: NaN
```


## Getting results and metrics
In the result above, the test achieved 57Mpps (rx-pps) bi-directional.
To get metrics from a particular run, follow these steps:

### Get the run-id
```
cd  /var/lib/crucible
cd trafficgen-2021-07-01_12:01:39/run/
xzcat rickshaw-run.json.xz | grep run-id
```
### Get the result for this run
```
crucible get result --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1
```

### Get the aggregated throughput (l1-tx-bps)
```
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1
```

The output should be as follows:
```
Checking for redis...appears to be running
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "trafficgen",
  "type": "l1-tx-bps",
  "label": "<cstype>-<csid>",
  "values": {
    "<client>-<1>": [
      {
        "begin": 1625147752047,
        "end": 1625147814267,
        "value": "3.872e+10"
      }
    ]
  },
  "breakouts": [
    "port_pair",
    "rx_port",
    "tx_port"
  ]
}
```
The aggregated throughput for this run was ~38Gbps.

### Getting additional metrics
#### trafficgen
```
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1,port_pair
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type tx-mpps --breakout cstype=client,csid=1,port_pair
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type tx-mpps
crucible get metric --run 32F5BD76-DA72-11EB-977F-A65A0D9F27D1 --period 67C8D7E8-DA74-11EB-883E-1E6B0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1,port_pair
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1,port_pair
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1,port_pair,tx_port
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source trafficgen --type l1-tx-bps --breakout cstype=client,csid=1,port_pair,tx_port,rx_port
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source trafficgen --type lost-rx-pps --breakout cstype=client,csid=1,port_pair,tx_port,rx_port
```

#### mpstat
```
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,num --filter gt:0.1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,num,package,die,core,thread --filter gt:0.1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,package,die,core --filter gt:0.1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,package,die,core,type --filter
gt:0.01
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,package=0,die=0,core=1,type
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,num,package=0,die=0,core=1,type
```

#### procstat
```
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source procstat --type interrupts-sec --breakout cstype=worker,csid=1
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source procstat --type interrupts-sec --breakout cstype=worker,csid=1,cpu=4
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source procstat --type interrupts-sec --breakout cstype=worker,csid=1,cpu=4,type
crucible get metric --run 9F84467A-DA85-11EB-888D-52BA0D9F27D1 --period FAE72C04-DA89-11EB-8DCC-EACA0D9F27D1 --source procstat --type interrupts-sec --breakout cstype=worker,csid=1,cpu=52,type
```
