# Begin with the end in Mind
This document is going to refer to some recent testing by the author as an example only, crucible is capable of testing all aspects of an individual system or cluster of systems.
## What are you testing
In this example we will consider testing three data paths of OVN-Kubernetes, the default, a hardware offloaded path, and a software data path based on `tc`. With that in mind we can make a plan for how to go about the testing and what we want the final report to look like. You can go so far as to mock up a chart to make sure that the shapes and colors assist your story telling.
## What story are you telling with this data
This testing will tell the story of throughput of three data paths. We will need context for the story to help the audience understand the contrast between the data paths. Two useful pieces of context are the link speed of the network interface used and the throughput of the default data path, so the audience will know how a new data path compares to the existing and how the overall throughput compares to what is theoretically possible with the chosen network interface.

# Tags
Tags are an affordance provided by crucible to aid you in keeping track of your results. They are a key value store that attaches to every invocation of `crucible run`, and are uploaded to the Elastic Search server along with your results and metrics. Use of tags is _highly_ recommended.
## Best Common Practices
A "top level" tag for your work is useful to separate the performance testing efforts that could be running simultaneously. Some tag names that have been used in the past are: "study: offloading", "jira:1885", "cpu:rome". Tags can also be used to delineate the runs that will be compared against each other, like "datapath: ovn-k", "datapath:ovn-k-tc","datapath:ovn-k-hw-offload". Depending on the `run.sh` that you are using or have modified, crucible will automatically create and populate tags like: mtu, kernel version, rcos, sdn, etc.

## Adding a tag after the run is done
Sometimes after a run is complete additional tags need to be added. For this crucible provides the `crucible tags` function. An example invocation of that command:
```bash
[root@localhost run]# crucible tags --action add --result-dir uperf--2022-05-03_19:34:02_UTC--bad895dc-9427-4ddb-86d9-10f0a5f1bedf --tags jira:1885
result: uperf--2022-05-03_19:34:02_UTC--bad895dc-9427-4ddb-86d9-10f0a5f1bedf
status: complete
tags:   sdn:OVNKubernetes, mtu:1400, rcos:411.85.202203242008-0, kernel:4.18.0-372.9.1.el8.mr2629_220429_1351.x86_64, irq:bal, userenv:stream8, osruntime:chroot, topo:intranode, pods-per-worker:1, scale_out_factor:1, datapath:ovn-k-tc, proto:tcp, test:stream, jira:1885
```

## Viewing the runs and Tags
Crucible also has a feature to show you the runs and tags that are stored on your local file system.
```
[root@dhcp31-35 run]# pwd
/var/lib/crucible/run
[root@localhost run]# crucible ls
result: uperf--2022-05-03_19:34:02_UTC--bad895dc-9427-4ddb-86d9-10f0a5f1bedf
status: complete
tags:   sdn:OVNKubernetes, mtu:1400, rcos:411.85.202203242008-0, kernel:4.18.0-372.9.1.el8.mr2629_220429_1351.x86_64, irq:bal, userenv:stream8, osruntime:chroot, topo:intranode, pods-per-worker:1, scale_out_factor:1, datapath:ovn-k-tc, proto:tcp, test:stream, jira:1885

result: uperf--2022-05-04_15:43:58_UTC--337c4c8f-eb38-4db0-8d3b-9c17a17b3f27
status: incomplete
tags:   sdn:OVNKubernetes, mtu:1400, rcos:411.85.202203242008-0, kernel:4.18.0-372.9.1.el8.mr2629_220429_1351.x86_64, irq:bal, userenv:stream8, osruntime:chroot, topo:internode, pods-per-worker:1, scale_out_factor:1

result: uperf--2022-05-04_17:17:39_UTC--34d94527-9c6b-4671-9e79-5a5340c557c3
status: incomplete
tags:   sdn:OVNKubernetes, mtu:1400, rcos:411.85.202203242008-0, kernel:4.18.0-372.9.1.el8.mr2629_220429_1351.x86_64, irq:bal, userenv:stream8, osruntime:chroot, topo:internode, pods-per-worker:1, scale_out_factor:1
```
In addition to showing the tags, `crucible ls` also shows you if the run completed successfully or not with the `status: complete` output.

# Test execution
## your run.sh
There is a [run.sh](https://github.com/perftool-incubator/crucible-examples/blob/main/uperf/run.sh) that is publicly available that can be modified for the desired use case. It is comment documented so that it can be reconfigured for your use case.

# Data collection
## Start Small
Using your locally modified `run.sh` file and `mv-params.json` setup some small tests to make sure you are sweeping through all the values you have configured, your environment is functioning as expected, and you are able to query the results that you intend to present. Crucible will upload data to the Elastic search server from the local file system at the end of every `crucible run`
## Mostly automated but check in on it
A common practice is to setup a large batch of test runs then "set it and forget it". This is useful when you want to start some long running testing perhaps overnight. While possible it is not advisable to load up a large amount of permutations in a `mv-params.json` and only have a single invocation of `crucible run`. Instead use an array of `mv-parms` files to have a larger number of smaller tests. 15-25 iterations per invocation of `crucible run` should be a good balance between automated runs and saving the output of testing. For example when doing networking related testing break up the tcp and udp tests. The right break up of tests will depend on the goals of the testing.


# Report Writing
The best medium for your report depends on your audience. For a chart heavy presentation a slideshow seems to be a better way to tell the story instead of a google doc or spread sheet. This does mean that you will need to use a tool to make the charts.

## Query your data
The human readable way to get your results is to use `crucible get result --run` this is sufficient for small quantities of data. If additional non-primary  metrics need to be displayed there is `crucible get metric --run` query to retrieve that information. As of this writing there are tools in development to aid a report author in organized data retrieval on a larger scale.

