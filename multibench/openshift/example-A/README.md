To run this test:
- copy `myconfig` to `thisconfig`
- edit `thisconfig` to specify your test bed's info
`ocp_host` needs to be set to an address which is reachable from the OpenShift pods.
- edit nodeSelector and resource files
If you are testing ipv6 update the iperf3 configuration file `iperf-mv-params.json` to use v6 addresses, the default is v4.
- run `./run.sh thisconfig`
