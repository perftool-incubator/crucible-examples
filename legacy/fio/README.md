# fio example

## Configuring to run the benchmark

Included are the files required to run crucible.  They are:

### mv-params.json

This file is used to define the measurements (ie. iterations) to run
and the unique parameters to use for each iteration.  Crucible will
generate all possible parameter combinations for each defined
iteration.

In this example there are two different iterations defined with
multiple block sizes to test for each.  Each iteration performs a
different kind of non-destructive read test (seequential and random)
for all defined block sizes in that iteration.  In total there are 5
differnt iterations to run.

### tool-params.json

This file is used to configure the tools to run while the workload is
executing in order to collect profile data.

### run.sh

This file shows how a 'crucible run' command is used to run fio on a
remotehost endpoint.

## Running the fio benchmark with Crucible

To run fio with Crucible, execute the `run.sh` script:

```
./run.sh
```

At the end of the run, you should get a result like:

```
run-id: 53709db8-d327-4943-99de-06b371824d92
  tags: remote-host=foo.bar.com run-type=example samples=3 userenv=rhubi8
  metrics:
    source: procstat
      types: interrupts-sec
    source: fio
      types: bw-KiBs completion-latency-usec iops latency-usec
    source: iostat
      types: avg-req-size-kB avg-service-time-ms kB-sec operations-sec avg-queue-length percent-utilization operations-merged-sec percent-merged
    source: mpstat
      types: NonBusy-CPU Busy-CPU
    source: sar-net
      types: errors-sec L2-Gbps packets-sec
    source: sar-scheduler
      types: IO-Blocked-Tasks Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length
    source: sar-mem
      types: KB-Paged-in-sec KB-Paged-out-sec Page-faults-sec Pages-freed-sec
    source: sar-tasks
      types: Context-switches-sec Processes-created-sec
  iterations:
    common params: clocksource=gettimeofday filename=/tmp/fio.foo ioengine=sync log_avg_msec=1000 log_hist_msec=10000 log_unix_epoch=1 norandommap=ON output-format=json output=fio-result.json ramp_time=5s runtime=10s size=10240k time_based=1 unlink=1 write_bw_log=fio write_hist_log=fio write_iops_log=fio write_lat_log=fio
    iteration-id: 563EAF66-A620-11EC-8DE0-6F42573275F7
      unique params: bs=64k rw=read
      primary-period name: measurement
      samples:
        sample-id: 565DE386-A620-11EC-8DE0-6F42573275F7
          primary period-id: 565E8B74-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541359768 end: 1647541369769
        sample-id: 58D84EF8-A620-11EC-8DE0-6F42573275F7
          primary period-id: 58D8F8C6-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541640460 end: 1647541650460
        sample-id: 5B5024E4-A620-11EC-8DE0-6F42573275F7
          primary period-id: 5B50A7CA-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541697413 end: 1647541707413
        result: (iops) samples: 7034.00 6213.00 7291.00 mean: 6846.00 min: 6213.00 max: 7291.00 stddev: 563.05 stddevpct: 8.22
    iteration-id: 5EFD9842-A620-11EC-8DE0-6F42573275F7
      unique params: bs=128k rw=read
      primary-period name: measurement
      samples:
        sample-id: 5F1D5BB4-A620-11EC-8DE0-6F42573275F7
          primary period-id: 5F1DDEEA-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541303877 end: 1647541313877
        sample-id: 619B8654-A620-11EC-8DE0-6F42573275F7
          primary period-id: 619C0DE0-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541473661 end: 1647541483661
        sample-id: 65491B04-A620-11EC-8DE0-6F42573275F7
          primary period-id: 65499750-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541753470 end: 1647541762472
        result: (iops) samples: 3640.00 3641.00 3331.00 mean: 3537.33 min: 3331.00 max: 3641.00 stddev: 178.69 stddevpct: 5.05
    iteration-id: 67C7F526-A620-11EC-8DE0-6F42573275F7
      unique params: bs=256k rw=read
      primary-period name: measurement
      samples:
        sample-id: 67E6FAC0-A620-11EC-8DE0-6F42573275F7
          primary period-id: 67E78C42-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541078081 end: 1647541088082
        sample-id: 6A5E32F0-A620-11EC-8DE0-6F42573275F7
          primary period-id: 6A5EC404-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541134012 end: 1647541144013
        sample-id: 6E0796EE-A620-11EC-8DE0-6F42573275F7
          primary period-id: 6E08221C-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541584469 end: 1647541594471
        result: (iops) samples: 1816.00 1766.00 1823.00 mean: 1801.67 min: 1766.00 max: 1823.00 stddev: 31.09 stddevpct: 1.73
    iteration-id: 7082333E-A620-11EC-8DE0-6F42573275F7
      unique params: bs=4k rw=randread
      primary-period name: measurement
      samples:
        sample-id: 70AF716E-A620-11EC-8DE0-6F42573275F7
          primary period-id: 70AFF77E-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541190935 end: 1647541200935
        sample-id: 746285BC-A620-11EC-8DE0-6F42573275F7
          primary period-id: 74631310-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541416692 end: 1647541426692
        sample-id: 76E64E40-A620-11EC-8DE0-6F42573275F7
          primary period-id: 76E6D284-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541530564 end: 1647541539564
        result: (iops) samples: 354400.00 358000.00 355400.00 mean: 355933.33 min: 354400.00 max: 358000.00 stddev: 1858.31 stddevpct: 0.52
    iteration-id: 795F6FEE-A620-11EC-8DE0-6F42573275F7
      unique params: bs=8k rw=randread
      primary-period name: measurement
      samples:
        sample-id: 797CD9D0-A620-11EC-8DE0-6F42573275F7
          primary period-id: 797D5964-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647540965249 end: 1647540975249
        sample-id: 7D25699E-A620-11EC-8DE0-6F42573275F7
          primary period-id: 7D25FA08-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541021182 end: 1647541031182
        sample-id: 7F9CAF52-A620-11EC-8DE0-6F42573275F7
          primary period-id: 7F9D3850-A620-11EC-8DE0-6F42573275F7
          period range: begin: 1647541247896 end: 1647541257896
        result: (iops) samples: 309800.00 315600.00 316100.00 mean: 313833.33 min: 309800.00 max: 316100.00 stddev: 3501.90 stddevpct: 1.12
```


## Getting results and metrics


### Get the run-id

The run-id is embedded in the result directory.  There are multiple ways to find this such as pulling it from the console log:

```
[root@localhost ~]# crucible log view last | grep "Archiving"
[2022-03-17 18:32:17.346][STDOUT] Archiving crucible log to /var/lib/crucible/run/fio--2022-03-17_18:14:24_UTC--53709db8-d327-4943-99de-06b371824d92/crucible.log.xz
```

Or by looking directly at the result directories (such as via the latest symbolic link):

```
[root@localhost ~]# ls -l /var/lib/crucible/run/latest
lrwxrwxrwx. 1 root root 88 Mar 17 13:14 /var/lib/crucible/run/latest -> /var/lib/crucible/run/fio--2022-03-17_18:14:24_UTC--53709db8-d327-4943-99de-06b371824d92
```

In either case, the run-id is UUID that is embedded in the result directory:

```
53709db8-d327-4943-99de-06b371824d92
```

### Get the result for this run

```
crucible get result --run 53709db8-d327-4943-99de-06b371824d92
```

The output of this command should be very similar to the above result.

### Querying for indivivdual sample data

Individual samples are currently denoted by the time period in which they ran -- so to query for that data you need to determine the period-id.

For the purpose of illustration, the period-id for the first sample of the `bs=64K rw=read` test is going to be used to show how to run queries:

```
565E8B74-A620-11EC-8DE0-6F42573275F7
```

In the report, the list of metrics defines the various sources (ie. benchmarks and/or tools) and types of data available from each source.  For simplicity, we start by looking at the primary fio metric which is iops:


```
crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source fio --type iops
```

The output should look something like this:

```
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "fio",
  "type": "iops",
  "label": "",
  "values": {
    "": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "7034"
      }
    ]
  },
  "breakouts": [
    "cmd",
    "csid",
    "cstype",
    "job"
  ]
}
```

Crucible metric reporting is done by aggragating all of the various components that in scope of the query.  The query engine supports the use of breakouts to disect the aggregated metrics should the user desire it.  More on that below.

### Getting additional metrics

#### fio

This particular example is not very complicated from an fio perspective -- there is a single client running on a single host -- so there is not a lot of aggregation being done.  That said, you can view other metrics in a similar manner to above.  For example:

```
[root@localhost ~]# crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source fio --type bw-KiBs
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "fio",
  "type": "bw-KiBs",
  "label": "",
  "values": {
    "": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "4.502e+5"
      }
    ]
  },
  "breakouts": [
    "cmd",
    "csid",
    "cstype",
    "job"
  ]
}
```

#### mpstat

The data collected by the mpstat subtool of the tool-sysstat package is sufficiently hierarchical to allow the demonstration of the aggregation behaiviors and breakout capabilities that Crucible possesses.  Let's start by focusing on the Busy-CPU metric to show CPU consumption:

```
[root@localhost ~]# crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source mpstat --type Busy-CPU
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "mpstat",
  "type": "Busy-CPU",
  "label": "",
  "values": {
    "": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.3316"
      }
    ]
  },
  "breakouts": [
    "core",
    "csid",
    "cstype",
    "die",
    "num",
    "package",
    "thread",
    "type"
  ]
}
```

This shows that in total 0.3316 (ie. 33.16%) of one CPU is being used during this measurement.  The breakout capabilities allow us to drill down into how that CPU load is actually distributed across the test environment.  First, the CPU utilization is broken down by the engine cstype (client/server type, client in this workload) and the csid (client/server id, 1 in this test):

```
[root@localhost ~]# crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source mpstat --type Busy-CPU --breakout cstype,csid
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "mpstat",
  "type": "Busy-CPU",
  "label": "<cstype>-<csid>",
  "values": {
    "<client>-<1>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.3316"
      }
   ]
  },
  "breakouts": [
    "core",
    "die",
    "num",
    "package",
    "thread",
    "type"
  ]
}
```

In this particular example, using the breakout did not accomplish much since there is only a single client on a single host the aggregated metric is the same as the broken out metric.  However, within that client there is a multi-core CPU so performing a breakout based on the CPU topology should reveal some interesting details of how this system is configured and running:

```
[root@localhost ~]# crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source mpstat --type Busy-CPU --breakout cstype,csid,thread
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "mpstat",
  "type": "Busy-CPU",
  "label": "<cstype>-<csid>-<thread>",
  "values": {
    "<client>-<1>-<0>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.2711"
      }
    ],
    "<client>-<1>-<1>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.06048"
      }
    ]
  },
  "breakouts": [
    "core",
    "die",
    "num",
    "package",
    "type"
  ]
}
```

This query is showing that the Busy-CPU is distributed across CPU threads 0 and 1.  The system this test was run on actually has 16 CPU threads (8 core w/ SMT) but Crucible only shows metrics with non-zero values in order to simplify things for the user.  You can continue to breakout the metrics even further to see where this Busy-CPU was consumed on a specific CPU thread:

```
[root@localhost ~]# crucible get metric --run 53709db8-d327-4943-99de-06b371824d92 --period 565E8B74-A620-11EC-8DE0-6F42573275F7 --source mpstat --type Busy-CPU --breakout cstype,csid,thread=0,type
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
{
  "name": "mpstat",
  "type": "Busy-CPU",
  "label": "<cstype>-<csid>-<thread>-<type>",
  "values": {
    "<client>-<1>-<0>-<soft>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.000"
      }
    ],
    "<client>-<1>-<0>-<sys>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.2595"
      }
    ],
    "<client>-<1>-<0>-<usr>": [
      {
        "begin": 1647541359768,
        "end": 1647541369769,
        "value": "0.01158"
      }
    ]
  },
  "breakouts": [
    "core",
    "die",
    "num",
    "package"
  ]
}
```

You can see that the majority of Busy-CPU time was spent in system (ie. kernel) which is a very logical for an I/O centric workload like fio.

## Summary

This example demonstrats how to run a simple fio workload and use the Crucible query engine to analyze the behavior of the system while the workload is running.  What is shown here is a very small subset of the queries that could be run on this data.  I would encourage you to experiment with the query engine beyond what is shown here in order to learn what you can do with it.
