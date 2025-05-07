# tracer-client

tracer-client is a Crucible interface for running the osnoise and timerlat workloads/tracers.

## Requirements

tracer-client depends on WORKLOAD_CPUS and HK_CPUS being defined in the Crucible environment.  If a tracer (osnoise or timerlat) and a run duration are not specified, tracer-client will default to using the osnoise tracer for a duration of 60 seconds.

## Usage

Tracer-client is invoked via the Crucible run command.  (crucible run tracer)  In this directory is provided an example shell script for running the tracer that demonstrates how various configuration options can be passed.  At a minimum, running bench-tracer requires an endpoint and that 'cpu-partitioning' be used so that WORKLOAD_CPUS and HK_CPUS will be defined.  'cpu-partitioning' is passed as an endpoint argument and can be seen in the file run.sh.

If running on a k8s endpoint, a nodeSelector will be required.  The nodeSelector will need to match the label on a k8s worker node where the bench-tracer should run.  An example nodeSecector (configured to match a worker node labeled with 'worker-cnf') is provided in this directory as nodeSelector.json.  The file resource.json is how CPU and memory requests and limits are configured.  If the running context is not able to read and write in the /sys/kernel/debug/tracing/ directory, Crucible's volumeMounts mechanism can be used to mount a writable copy of /sys/kernel/debug/tracing/* .  The files used for this are volumeMounts.json and volumes.json.  They can be used as-is without modification.

The primary configuration file for passing values to bench-tracer is the mv-params.json file.  Each of the options listed below can be configured in mv-params.  One thing to note is that the tracepoint configuration can enable multiple tracepoints at once by passing a comma-separated list of tracepoints via the --events flag.

## tracer-client Options

**--tracer** *(must be either 'osnoise' or 'timerlat')*

**--duration** *how long to collect trace data, in seconds*

## OSNOISE/TIMERLAT Tracer Options

[Full tracer documentation](https://www.kernel.org/doc/html/latest/trace/osnoise-tracer.html) is beyond the scope of this README.  These are the options for passing values through to the tracer.

**--period** *sets osnoise/period_us*

**--runtime** *sets osnoise/runtime_us*

**--us_single** *sets osnoise/stop_tracing_us or osnoise/stop_tracing_in_us depending on which is present in your kernel version*

**--us_total** *sets osnoise/stop_tracing_total_us or osnoise/stop_tracing_out_us depending on which is present in your kernel version*

**--threshold** *sets osnoise/tracing_threshold if it is present in your kernel version*


## Generic Tracing Options

**--stack** *sets /sys/kernel/debug/tracing/stack_trace*

**--cpu** *causes the tracer to print the results of per_cpu/cpu**X**/trace instead of a trace including all CPUs in /sys/kernel/debug/tracing/tracing_cpumask.  By default, tracing_cpumask will contain the CPUs listed in WORKLOAD_CPUS*

## Tracepoint Support

**--events** *takes a comma separated list of events in /sys/kernel/debug/tracing/osnoise (currently 'osnoise', 'irq_noise', 'nmi_noise', 'sample_threshold', 'softirq_noise' and 'thread_noise') and enables the tracepoint for any event in the list*
