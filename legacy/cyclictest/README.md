Running the cyclictest benchmark with crucible

Included are the files required to run crucible.  They are:

bench-params.json: at a minimum, set your duration in this file.  You can also set scheduler-policy ("policy"), scheduler-priority ("priority"), and the cyclictest-interval ("interval").

resources.json: This file is only necessary if you are using the k8s endpoint.  For k8s, we expect that the static CPU policy is available, and you should set the cpu request and limit to the same number, this number being a positive integer.  Memory request and limit should also have a matching value (like 2048M).

nodeSelector.json: This file is only necessary if you are using the k8s endpoint.  In this file, you can specify which worker node this benchmark runs on.

run.sh:  This file shows how a 'crucible run' command is used to run cyclictest on a k8s cluster.  If you want to run cyclictest on a regular host, you will need to use the remotehost endpoint.

At the end of the run, you should have output like:

Generating benchmark summary report

```
run-id: 1254FF72-88C5-11EB-94C4-93C5F6521EE9
  tags:
  metrics:
    source: procstat
      types: interrupts-sec
    source: mpstat
      types: Busy-CPU NonBusy-CPU
    source: sar-net
      types: L2-Gbps
    source: sar-scheduler
      types: Context-switches-sec Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length
    source: sar-mem
      types: KB-Paged-out-sec Page-faults-sec Pages-freed-sec KB-Paged-in-sec
    source: sar-tasks
      types: Processes-created-sec
    source: cyclictest
      types: wakeup-latency-usec
    source: sar-io
      types: IO-Blocked-Tasks
  iterations:
    iteration-id: 8DC3DB6A-88C5-11EB-B428-BECFF6521EE9
      params: duration=30 priority=95
period-id: 8DC7A704-88C5-11EB-B428-BECFF6521EE9
periodRange: {"begin":1616166665744,"end":1616166695808}
      result: (wakeup-latency-usec) samples: 6.00 mean: 6.00 stddev: 0.00 stddevpct: 0.00
```

The primary metric, wakeup-latency-usec, is the maximum wakeup latency from all CPUs used in the test.  Currently the minimum, average, and maximum latency, per-cpu, is not captured in the results (but it will be with a later update).  To see the raw results from cyclictest, go to /var/lib/crucible/run/latest/run/interation, and there will be interation and sample directories under there with 'histogram.txt' file from cyclictest.

