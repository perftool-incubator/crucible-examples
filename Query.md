# Query your Results and Metrics
## Glossary
* **metric** - the tool or benchmark that gathered data
* **metric type** - transactions, throughput, etc
* **iteration** - a uniqe set of benchmark parameters
* **sample** - a re-run of an iteration for greater statistical confidence
* **cstype** - a worker, master, client, or server. initially was short for client server type. but with workers and masters the name is ill fitting
* **csid** - the id of the cstype, worker-1 for example
* **package** - like a numanode
* **type** - the type of cpu, user, sys, etc

## Metrics
Metrics are collected over a time range.
### How are the metrics Stored
Crucible only grabs metrics that are the most granular / "broken out" metric that the tools provide. IE if a tool reports the average cpu usage, crucible doesn't collect it. Crucible Aggregates in Elastic Search.

## Results
1. Select your run id
2. select the time range within the run id
3. select the sources of data that you wish, mpstat, uperf for example
4. run the query via `crucible get`

Run id is found in `rickshaw-run.json` inside `/var/lib/crucible/run/`
## Examples
* `crucible get result --run <RUN-ID> `, will list all metrics available, by source and type
* `crucible get metric --run <RUN-ID> --begin <start> --end <final_time> --source mpstat --type Busy-CPU`

will return a value, but also provides `breakouts`, which can be thought of as metadata.

* `crucible get metric --run <RUN-ID> --begin <start> --end <final_time> --source mpstat --type Busy-CPU --breakout cstype,csid`
* `crucible get metric --run <RUN-ID> --begin <start> --end <final_time> --source mpstat --type Busy-CPU --breakout cstype=worker,csid=1,package`

* use `--resolution=90` to get the desired number of samples from the run. just like a picture you can only enhance so far before it doesn't get any clearer. try a resolution that matches the duration of a test
* `crucible get metric --run <RUN-ID> --begin <start> --end <final_time> --source mpstat --type Busy-CPU --breakout cstype,csid --resolution 60`

