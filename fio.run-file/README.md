# fio example

## Configuring to run the benchmark

Included are the files required to run crucible.  They are:

### fio.json

This 'run-file' contains all of the necessary information to run a
complex (multi-iteration, multi-sample) set of fio benchmarks on a
'remotehost' endpoint (ie. a Linux box).

### run.sh

This file shows how a 'crucible run' command is used to run fio on a
remotehost endpoint.  At the top of the file are a few values the user
can change in order to direct where the test should be run and modify
some aspects of it's behavior such as sample count and userenv (the
userenv is the base Linux container that is used to build the run
environment where fio will execute).

## Running the fio benchmark with Crucible

To run fio with Crucible, execute the `run.sh` script:

```
./run.sh
```

At the end of the run, you should get a result summary like:

```
run-id: cccaaab6-1198-4605-bfac-1ad40ec944a3
  tags: run-type=example
  benchmark: fio
  common params: clocksource=gettimeofday filename=/tmp/fio.foo ioengine=sync log_avg_msec=1000 log_hist_msec=10000 log_unix_epoch=1 norandommap=ON output-format=json output=fio-result.json ramp_time=5s runtime=10
s size=10240k time_based=1 unlink=1 write_bw_log=fio write_hist_log=fio write_iops_log=fio write_lat_log=fio
  metrics:
    source: fio
      types: bw-KiBs completion-latency-usec iops latency-usec
    source: iostat
      types: avg-service-time-ms operations-sec avg-req-size-kB kB-sec avg-queue-length percent-utilization operations-merged-sec percent-merged
    source: mpstat
      types: Busy-CPU NonBusy-CPU
    source: sar-net
      types: errors-sec packets-sec L2-Gbps
    source: sar-mem
      types: KB-Paged-in-sec KB-Paged-out-sec Page-faults-sec Pages-freed-sec Pages-swapped-in-sec VM-Efficiency kswapd-scanned-pages-sec reclaimed-pages-sec
    source: procstat
      types: interrupts-sec
    source: sar-scheduler
      types: Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length
    source: sar-tasks
      types: Context-switches-sec Processes-created-sec
    iteration-id: 8043698A-5F08-11EE-86BF-1509D9EBE5A0
      unique params: bs=64k rw=read
      primary-period name: measurement
      samples:
        sample-id: 80C32BCA-5F08-11EE-81F5-69C587B7B1D5
          primary period-id: 80C41BF2-5F08-11EE-81F5-69C587B7B1D5
          period range: begin: 1696019073376 end: 1696019083377
        sample-id: 80D9883E-5F08-11EE-8E69-69C587B7B1D5
          primary period-id: 80DA217C-5F08-11EE-9E4A-69C587B7B1D5
          period range: begin: 1696019663170 end: 1696019672171
        sample-id: 80CD0C08-5F08-11EE-91BA-69C587B7B1D5
          primary period-id: 80CDB20C-5F08-11EE-91BA-69C587B7B1D5
          period range: begin: 1696019268336 end: 1696019278337
            result: (fio::iops) samples: 27014.793641 26172.037658 28566.075585 mean: 27250.968961 min: 26172.037658 max: 28566.075585 stddev: 1214.367525 stddevpct: 4.456236
    iteration-id: 80E2DBE6-5F08-11EE-A2E7-69C587B7B1D5
      unique params: bs=128k rw=read
      primary-period name: measurement
      samples:
        sample-id: 813D8D34-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 813DDA46-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019958952 end: 1696019968953
        sample-id: 812DA536-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 812E3B86-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019861035 end: 1696019871036
        sample-id: 811E2584-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 811E79BC-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696018681633 end: 1696018691634
            result: (fio::iops) samples: 14184.665167 14231.628574 14103.938612 mean: 14173.410785 min: 14103.938612 max: 14231.628574 stddev: 64.584653 stddevpct: 0.455675
    iteration-id: 81447D9C-5F08-11EE-911D-69C587B7B1D5
      unique params: bs=256k rw=read
      primary-period name: measurement
      samples:
        sample-id: 816B1F38-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 816B661E-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019564190 end: 1696019573190
        sample-id: 8171EDEA-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81723674-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019762098 end: 1696019772099
        sample-id: 81648AA6-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 8164D3BC-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696018582679 end: 1696018592681
            result: (fio::iops) samples: 6135.992667 6528.049990 6901.784965 mean: 6521.942541 min: 6135.992667 max: 6901.784965 stddev: 382.932678 stddevpct: 5.871451
    iteration-id: 81788C90-5F08-11EE-911D-69C587B7B1D5
      unique params: bs=4k rw=randread
      primary-period name: measurement
      samples:
        sample-id: 81A8273E-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81A86BB8-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019171335 end: 1696019181336
        sample-id: 819A95BA-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 819AE20E-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696018876520 end: 1696018885520
        sample-id: 81A15F94-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81A1A922-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696018974617 end: 1696018983617
            result: (fio::iops) samples: 459789.210058 467196.299856 479779.066548 mean: 468921.525487 min: 459789.210058 max: 479779.066548 stddev: 10105.983041 stddevpct: 2.155154
    iteration-id: 81AEC9EA-5F08-11EE-911D-69C587B7B1D5
      unique params: bs=8k rw=randread
      primary-period name: measurement
      samples:
        sample-id: 81DB9146-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81DBDA48-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019466256 end: 1696019476256
        sample-id: 81CDE578-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81CE321C-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696018777441 end: 1696018787441
        sample-id: 81D484A0-5F08-11EE-911D-69C587B7B1D5
          primary period-id: 81D4E0DA-5F08-11EE-911D-69C587B7B1D5
          period range: begin: 1696019367338 end: 1696019377338
            result: (fio::iops) samples: 416636.605739 410590.978802 436340.933507 mean: 421189.506016 min: 410590.978802 max: 436340.933507 stddev: 13465.203954 stddevpct: 3.196947
```

## Getting results and metrics


### Get the run-id

The run-id is embedded in the result directory.  There are multiple ways to find this such as pulling it from the console log:

```
[root@localhost ~]# crucible log view last | grep "Archiving"
[2023-09-29 20:41:18.465][STDOUT] Archiving crucible log to /var/lib/crucible/run/fio--2023-09-29_20:13:54_UTC--cccaaab6-1198-4605-bfac-1ad40ec944a3/crucible.log.xz
```

Or by looking directly at the result directories (such as via the latest symbolic link):

```
[root@localhost ~]# ls -l /var/lib/crucible/run/latest
lrwxrwxrwx. 1 root root 88 Sep 29 15:13 /var/lib/crucible/run/latest -> /var/lib/crucible/run/fio--2023-09-29_20:13:54_UTC--cccaaab6-1198-4605-bfac-1ad40ec944a3
```

In either case, the run-id is a UUID that is embedded in the result directory:

```
cccaaab6-1198-4605-bfac-1ad40ec944a3
```

### Get the result for this run

```
crucible get result --run cccaaab6-1198-4605-bfac-1ad40ec944a3
```

The output of this command should be very similar to the above result.

### Querying for indivivdual sample data

Individual samples are currently denoted by the time period in which they ran -- so to query for that data you need to determine the period-id.

For the purpose of illustration, the period-id for the first sample of the `bs=64K rw=read` test is going to be used to show how to run queries:

```
80C41BF2-5F08-11EE-81F5-69C587B7B1D5
```

In the report, the list of metrics defines the various sources (ie. benchmarks and/or tools) and types of data available from each source.  For simplicity, we start by looking at the primary fio metric which is iops:


```
crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source fio --type iops
```

The output should look something like this:

```
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  cmd,csid,cstype,job

             29-08-2023
 source type   20:24:43
-----------------------
    fio iops   27014.79
```

Crucible metric reporting is done by aggragating all of the various components that in scope of the query.  The query engine supports the use of breakouts to disect the aggregated metrics should the user desire it.  More on that below.

### Getting additional metrics

#### fio

This particular example is not very complicated from an fio perspective -- there is a single client running on a single host -- so there is not a lot of aggregation being done.  That said, you can view other metrics in a similar manner to above.  For example:

```
[root@localhost ~]# crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source fio --type bw-KiBs
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  cmd,csid,cstype,job

                29-08-2023
 source    type   20:24:43
--------------------------
    fio bw-KiBs 1728967.20
```

#### mpstat

The data collected by the mpstat subtool of the tool-sysstat package is sufficiently hierarchical to allow the demonstration of the aggregation behaiviors and breakout capabilities that Crucible possesses.  Let's start by focusing on the Busy-CPU metric to show CPU consumption:

```
[root@localhost ~]# crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source mpstat --type Busy-CPU
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,csid,cstype,die,num,package,thread,type

                 29-08-2023
 source     type   20:24:43
---------------------------
 mpstat Busy-CPU       0.87
```

This shows that in total 0.87 (ie. 87%) of one CPU is being used during this measurement.  The breakout capabilities allow us to drill down into how that CPU load is actually distributed across the test environment.  First, the CPU utilization is broken down by the engine cstype (client/server type, client in this workload) and the csid (client/server id, 1 in this test):

```
[root@localhost ~]# crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source mpstat --type Busy-CPU --breakout cstype,csid
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,die,num,package,thread,type

                             29-08-2023
 source     type cstype csid   20:24:43
---------------------------------------
 mpstat Busy-CPU client    1       0.87
```

In this particular example, using the breakout did not accomplish much since there is only a single client on a single host the aggregated metric is the same as the broken out metric.  However, within that client there is a multi-core CPU so performing a breakout based on the CPU topology should reveal some interesting details of how this system is configured and running:

```
[root@localhost ~]# crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source mpstat --type Busy-CPU --breakout cstype,csid,thread
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,die,num,package,type

                                    29-08-2023
 source     type cstype csid thread   20:24:43
----------------------------------------------
 mpstat Busy-CPU client    1      0       0.87
```

This query is showing that the Busy-CPU is only present on CPU thread 0.  The system this test was run on was a virtual machine with 4 logical CPUs but Crucible only shows metrics with non-zero values in order to simplify things for the user.  This virtual machine had cpu-partitioning enabled and all CPUs except CPU 0 were "isolated" so the fio workload could not run there, resulting in no CPU load on any thread other than 0.  You can continue to breakout the metrics even further to see where this Busy-CPU was consumed on a specific CPU thread:

```
[root@localhost ~]# crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 --source mpstat --type Busy-CPU --breakout cstype,csid,thread=0,type
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,die,num,package,thread

                                            29-08-2023
 source     type cstype csid thread=0  type   20:24:43
------------------------------------------------------
 mpstat Busy-CPU client    1        0 gnice       0.00
 mpstat Busy-CPU client    1        0 guest       0.00
 mpstat Busy-CPU client    1        0   irq       0.02
 mpstat Busy-CPU client    1        0  nice       0.00
 mpstat Busy-CPU client    1        0  soft       0.00
 mpstat Busy-CPU client    1        0   sys       0.80
 mpstat Busy-CPU client    1        0   usr       0.05
```

You can see that the majority of Busy-CPU time was spent in system (ie. kernel) which is a very logical for an I/O centric workload like fio.

## Summary

This example demonstrats how to run a simple fio workload and use the Crucible query engine to analyze the behavior of the system while the workload is running.  What is shown here is a very small subset of the queries that could be run on this data.  I would encourage you to experiment with the query engine beyond what is shown here in order to learn what you can do with it.
