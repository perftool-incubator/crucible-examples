# Configuring to run a benchmark
Crucible's `runfile` is a  JSON file that contains all of the necessary
information to run a complex, multi-iteration, and multi-sample set of
supported benchmarks on a requested endpoint.

Examples can be found in the [runfile/](runfile/) directory. More
details about the Crucible runfile can be found in the [runfile doc](runfile/README.md).

# Running a benchmark with Crucible
```
crucible run --from-file <run-file-name>.json
```

## Result summary
At the end of the run, you should get a result summary like:

```
Generating benchmark summary report:
get_result_backend --run e3cc6bbd-1167-491f-b4f6-b5237e513e51 --output-format json,yaml,txt --output-dir /var/lib/crucible/run/osnoise--2025-05-07_14:25:35_UTC--e3cc6bbd-1167-491f-b4f6-b5237e513e51/run

run-id: e3cc6bbd-1167-491f-b4f6-b5237e513e51
  tags: arm_dsu_pmu=disabled kernel=6.12.0-67.1000Hz kernel_params=realtime_extra_params no_balance_cores=no os=rhel10 stop_threshold=none tuned=realtime
  benchmark: osnoise
  common params: cpus=3-127 duration=60 house-keeping=2 period=1000000 priority=f:2 runtime=950000 smt=off threshold=1 warm-up=60
  metrics:
    source: procstat
      types: interrupts-sec
    source: osnoise
      types: polling-latency-usec
    iteration-id: FE944A8E-2B53-11F0-936C-8FF02FF885EC
      unique params:
      primary-period name: measurement
      samples:
        sample-id: FE9E6852-2B53-11F0-B3B4-D26C1EE890EE
          primary period-id: FE9EDF94-2B53-11F0-B333-800713C1364A
          period range: begin: 1746628961108 end: 1746629087141
          period length: 126.033 seconds
            result: (osnoise::polling-latency-usec) samples: 48.000000 mean: 48.000000 min: 48.000000 max: 48.000000 stddev: NaN stddevpct: NaN

Benchmark summary is complete and can be found in:
/var/lib/crucible/run/osnoise--2025-05-07_14:25:35_UTC--e3cc6bbd-1167-491f-b4f6-b5237e513e51/run/result-summary.[txt|json|yaml]
Archiving crucible log to /var/lib/crucible/run/osnoise--2025-05-07_14:25:35_UTC--e3cc6bbd-1167-491f-b4f6-b5237e513e51/crucible.log.xz
```

## Update
If you see this warning, your Crucible installation is not up-to-date:
```
*** NOTICE: Crucible is at least 12 commits behind.  See 'crucible repo info' for details. ***
```

Update Crucible:
```
crucible update
```


# Gettings results

Get the run-id of your latest run:
```
# crucible log view last | grep run-id:
[2025-05-06 16:22:12.684][STDOUT] run-id: 1c5d81fb-13cc-4749-8947-46d03717705c
```
Latest results can be found at `/var/lib/crucible/run/latest`.


Show the result summary:
```
crucible get result --run 1c5d81fb-13cc-4749-8947-46d03717705c
```

# Exploring metrics
In the report, the list of metrics defines the various sources (ie. benchmarks
and/or tools) and types of data available from each source.
```
...
  metrics:
    source: fio
      types: bw-KiBs completion-latency-usec iops latency-usec
...
```
Metrics are associated to a period like:
```
      samples:
        sample-id: 80C32BCA-5F08-11EE-81F5-69C587B7B1D5
          primary period-id: 80C41BF2-5F08-11EE-81F5-69C587B7B1D5
```
For simplicity, we start by looking at the primary fio metric which is iops:
```
crucible get metric --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                    --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                    --source fio --type iops
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

Crucible metric reporting is done by aggragating all of the various components
that are in scope of the query. The query engine supports the use of breakouts
to dissect the aggregated metrics should the user desire it. More on that
below.

### Getting additional metrics

#### fio

This particular example is not very complicated from an fio perspective --
there is a single client running on a single host -- so there is not a lot of
aggregation being done.  That said, you can view other metrics in a similar
manner to above.  For example:

```
[root@localhost ~]# crucible get metric \
                             --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                             --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                             --source fio --type bw-KiBs
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  cmd,csid,cstype,job

                29-08-2023
 source    type   20:24:43
--------------------------
    fio bw-KiBs 1728967.20
```

#### mpstat

The data collected by the mpstat subtool of the tool-sysstat package is
sufficiently hierarchical to allow the demonstration of the aggregation
behaiviors and breakout capabilities that Crucible possesses.  Let's
start by focusing on the Busy-CPU metric to show CPU consumption:

```
[root@localhost ~]# crucible get metric \
                             --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                             --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                             --source mpstat --type Busy-CPU
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,csid,cstype,die,num,package,thread,type

                 29-08-2023
 source     type   20:24:43
---------------------------
 mpstat Busy-CPU       0.87
```

This shows that in total 0.87 (ie. 87%) of one CPU is being used during this
measurement.  The breakout capabilities allow us to drill down into how that
CPU load is actually distributed across the test environment. First, the CPU
utilization is broken down by the engine cstype (client/server type, client in
this workload) and the csid (client/server id, 1 in this test):

```
[root@localhost ~]# crucible get metric \
                             --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                             --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                             --source mpstat --type Busy-CPU \
                             --breakout cstype,csid
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,die,num,package,thread,type

                             29-08-2023
 source     type cstype csid   20:24:43
---------------------------------------
 mpstat Busy-CPU client    1       0.87
```

In this particular example, using the breakout did not accomplish much since
there is only a single client on a single host the aggregated metric is the
same as the broken out metric.  However, within that client there is a
multi-core CPU so performing a breakout based on the CPU topology should
reveal some interesting details of how this system is configured and running:

```
[root@localhost ~]# crucible get metric \
                             --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                             --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                             --source mpstat --type Busy-CPU \
                             --breakout cstype,csid,thread
Checking for httpd...appears to be running
Checking for elasticsearch...appears to be running
Available breakouts:  core,die,num,package,type

                                    29-08-2023
 source     type cstype csid thread   20:24:43
----------------------------------------------
 mpstat Busy-CPU client    1      0       0.87
```

This query is showing that the Busy-CPU is only present on CPU thread 0. The
system this test was run on was a virtual machine with 4 logical CPUs but
Crucible only shows metrics with non-zero values in order to simplify things
for the user.  This virtual machine had cpu-partitioning enabled and all CPUs
except CPU 0 were "isolated" so the fio workload could not run there, resulting
in no CPU load on any thread other than 0.  You can continue to breakout the
metrics even further to see where this Busy-CPU was consumed on a specific CPU
thread:

```
[root@localhost ~]# crucible get metric \
                             --run cccaaab6-1198-4605-bfac-1ad40ec944a3 \
                             --period 80C41BF2-5F08-11EE-81F5-69C587B7B1D5 \
                             --source mpstat --type Busy-CPU \
                             --breakout cstype,csid,thread=0,type
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

You can see that the majority of Busy-CPU time was spent in system (ie. kernel)
which is a very logical for an I/O centric workload like fio.
