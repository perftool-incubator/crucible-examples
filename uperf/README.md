# Uperf

This directory contains a script, run.sh, which will run uperf tests via crucible test harness.  This script can run multiple network topologies, and the default is "internode", which is a network topology for a k8s cluster requiring two worker nodes, and where the uperf client is on the first worker node, and the uperf server is on the second worker node.  Please see comments in run.sh on what can be changed to suit your specific environment and change the types of tests that are run.  Additionally, you may alter "uperf-mv-params.json" to change the benchmark parameters for uperf (like the message size, test duration. number of threads, etc).  For details on this file format, please see https://github.com/perftool-incubator/multiplex

Once you have made changes to run.sh and optionally uperf-mv-params.json, you will need to ensure that password-less ssh is configured for your "admin" host if using k8s/Openshift (typically the host respsonsible for provisioning your environment, or a host with cluster admin rights).  If you are testing a network topology involving other remote hosts (baremetal, VM, etc), the this host also needs password-less ssh to those hosts.  For example, if "interhost" topology is used, ssh must work for "bmlhosta" and "bmlhostb" defined in run.sh.

Before running any tests, be sure to install crucible on this host: https://github.com/perftool-incubator/crucible

Once crucible is installed, you only need to run "./run.sh" to start the tests.  If uperf-mv-params.json is not changed, 12 different benchmark "iterations" will be run.  Each iteration is a specific combination of unique benchmark perameters (like test-type=stream, wsize=16384, nthreads=1, protocol=tcp).  Each benchmark iteration is run N times, based on the value used for the "samples=N" in the run.sh.  So, in the default case there will be 12 iterations * 3 samples each = 36 total tests run.

After the run is complete, you should have a summary output like:

<pre>
run-id: 9E76DB58-CE3C-11EB-8F5A-6C4FFD9E27D1
  tags: irq=bal kernel=4.18.0-240.22.1.el8_3.x86_64 mtu=8900 osruntime=pod pods-per-worker=1 rcos=47.83.202104090345-0 scale_out_factor=1 sdn=OVNKubernetes topo=internode userenv=stream 
  metrics:
    source: procstat
      types: interrupts-sec 
    source: mpstat
      types: Busy-CPU NonBusy-CPU 
    source: sar-net
      types: L2-Gbps packets-sec errors-sec 
    source: uperf
      types: Gbps round-trip-usec transactions-sec 
    source: ovs
      types: conntrack dpctl-mem 
    source: sar-scheduler
      types: IO-Blocked-Tasks Load-Average-01m Load-Average-05m Load-Average-15m Process-List-Size Run-Queue-Length 
    source: sar-mem
      types: Page-faults-sec KB-Paged-in-sec KB-Paged-out-sec Pages-freed-sec 
    source: sar-tasks
      types: Context-switches-sec Processes-created-sec 
  iterations:
    iteration-id: A3263762-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=udp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A328B172-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3296D9C-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808995526 end: 1623809085817
        sample-id: A32B32E4-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A32BF4B8-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623809152781 end: 1623809243071
        sample-id: A32DD198-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A32E7F94-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623809310018 end: 1623809400311
        result: (Gbps) samples: 102.90 103.20 103.10 mean: 103.07 stddev: 0.15 stddevpct: 0.15
    iteration-id: A2E553AA-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=tcp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A2E85ADC-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2E9578E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806078078 end: 1623806168367
        sample-id: A2EB26E0-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2EBDAA4-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806234868 end: 1623806325158
        sample-id: A2EDB0AE-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2EE744E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806392637 end: 1623806482929
        result: (Gbps) samples: 24.51 24.53 24.50 mean: 24.51 stddev: 0.02 stddevpct: 0.06
    iteration-id: A348E5E6-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=tcp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3547FFA-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A35556F0-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810956172 end: 1623811046464
        sample-id: A34BC48C-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A34C8DF4-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810644521 end: 1623810734817
        sample-id: A3501FB4-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A350E23C-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810800865 end: 1623810891156
        result: (transactions-sec) samples: 21590.00 21480.00 21730.00 mean: 21600.00 stddev: 125.30 stddevpct: 0.58
    iteration-id: A3D1F138-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=udp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3D4C5D4-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3D57574-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814415173 end: 1623814505469
        sample-id: A3D8B5E0-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3D9590A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814572447 end: 1623814662741
        sample-id: A3DC911A-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3DD3D40-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814728712 end: 1623814819007
        result: (transactions-sec) samples: 113100.00 114200.00 111800.00 mean: 113033.33 stddev: 1201.39 stddevpct: 1.06
    iteration-id: A2CFC7D8-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=tcp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A2D25D0E-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2D3156E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805135327 end: 1623805225619
        sample-id: A2D4FD16-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2D5C3C2-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805292730 end: 1623805383027
        sample-id: A2D7D310-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2D88832-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805449122 end: 1623805539417
        result: (Gbps) samples: 19.09 18.98 18.92 mean: 19.00 stddev: 0.09 stddevpct: 0.45
    iteration-id: A2F0B524-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=tcp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A2F871A6-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2F92C40-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806869397 end: 1623806959687
        sample-id: A2F6042A-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2F6B424-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806710377 end: 1623806800667
        sample-id: A2F34B5E-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2F40666-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623806550373 end: 1623806640663
        result: (Gbps) samples: 24.46 24.28 24.35 mean: 24.36 stddev: 0.09 stddevpct: 0.37
    iteration-id: A33C1802-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=udp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A34380B0-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A34454F4-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810330601 end: 1623810420594
        sample-id: A34046A2-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3414912-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810173293 end: 1623810263560
        sample-id: A3463026-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A346E21E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623810486784 end: 1623810576229
        result: (Gbps) samples: 232.70 232.60 176.40 mean: 213.90 stddev: 32.48 stddevpct: 15.18
    iteration-id: A3591B3C-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=tcp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A35FFD8A-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A360AB22-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811270135 end: 1623811360431
        sample-id: A363EFB2-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A36497A0-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811425409 end: 1623811515701
        sample-id: A35BE15A-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A35CA0B8-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811112680 end: 1623811202974
        result: (transactions-sec) samples: 10230.00 10280.00 10250.00 mean: 10253.33 stddev: 25.17 stddevpct: 0.25
    iteration-id: A3062A80-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=udp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A308CC22-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A309954E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807505406 end: 1623807595697
        sample-id: A30DCFCE-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A30E8680-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807818069 end: 1623807908359
        sample-id: A30B4CEA-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A30BFD2A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807661740 end: 1623807752031
        result: (Gbps) samples: 0.10 0.10 0.10 mean: 0.10 stddev: 0.00 stddevpct: 2.10
    iteration-id: A3110158-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=udp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A3188A04-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A31942B4-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808290324 end: 1623808380615
        sample-id: A3160FB8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A316BD14-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808131727 end: 1623808222018
        sample-id: A3139B84-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3144EB2-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807976417 end: 1623808066708
        result: (Gbps) samples: 11.94 12.10 12.21 mean: 12.08 stddev: 0.14 stddevpct: 1.12
    iteration-id: A38B0AD4-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=tcp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A38E11C0-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A38ED5CE-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812529339 end: 1623812619629
        sample-id: A391F86C-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A392A186-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812686355 end: 1623812776645
        sample-id: A398BECC-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3997754-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812843642 end: 1623812933932
        result: (transactions-sec) samples: 598200.00 608700.00 612500.00 mean: 606466.67 stddev: 7406.98 stddevpct: 1.22
    iteration-id: A3AECDDE-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=udp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3B5AB04-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3B66210-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813631333 end: 1623813721628
        sample-id: A3B1AF68-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3B276B4-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813474546 end: 1623813564845
        sample-id: A3BC7AD8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3BD2A1E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813787743 end: 1623813878038
        result: (transactions-sec) samples: 22510.00 22230.00 22080.00 mean: 22273.33 stddev: 218.25 stddevpct: 0.98
    iteration-id: A3EEE126-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=udp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3F97A3C-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3FA2EE6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815676522 end: 1623815766818
        sample-id: A3F1ADDE-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3F27FDE-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815364164 end: 1623815454457
        sample-id: A3F5B3F2-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3F656B8-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815519371 end: 1623815609673
        result: (transactions-sec) samples: 125500.00 131000.00 130600.00 mean: 129033.33 stddev: 3066.49 stddevpct: 2.38
    iteration-id: A31B91E0-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=udp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A320AA72-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3215D82-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808650931 end: 1623808740220
        sample-id: A32321EE-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A323CFD6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808840206 end: 1623808930496
        sample-id: A31E39B8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A31EF678-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623808447668 end: 1623808537958
        result: (Gbps) samples: 1.17 1.17 1.20 mean: 1.18 stddev: 0.02 stddevpct: 1.64
    iteration-id: A3684076-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=tcp rsize=1024 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3751274-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A375BF3A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811894408 end: 1623811984698
        sample-id: A36B05CC-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A36BB5F8-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811581839 end: 1623811672129
        sample-id: A3711124-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A372057A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623811738535 end: 1623811828825
        result: (transactions-sec) samples: 259900.00 259600.00 259300.00 mean: 259600.00 stddev: 300.00 stddevpct: 0.12
    iteration-id: A37935D4-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=tcp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A37C241A-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A37CCE6A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812057231 end: 1623812147521
        sample-id: A386A764-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A38764A6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812371649 end: 1623812461939
        sample-id: A37FF3E2-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A380A918-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623812212903 end: 1623812303197
        result: (transactions-sec) samples: 145300.00 134500.00 144800.00 mean: 141533.33 stddev: 6096.17 stddevpct: 4.31
    iteration-id: A39CEA9C-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=tcp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A39FE198-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3A09E6C-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813001659 end: 1623813091949
        sample-id: A3AA8940-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3AB4312-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813318635 end: 1623813408925
        sample-id: A3A3F9AE-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3A4B27C-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813159663 end: 1623813249956
        result: (transactions-sec) samples: 186700.00 186800.00 186800.00 mean: 186766.67 stddev: 57.74 stddevpct: 0.03
    iteration-id: A2DAA18A-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=tcp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A2DD3CD8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2DE19C8-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805605660 end: 1623805695950
        sample-id: A2DFD3F8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2E09D10-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805762356 end: 1623805852647
        sample-id: A2E28198-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2E3376E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623805920356 end: 1623806010646
        result: (Gbps) samples: 14.48 14.28 14.52 mean: 14.43 stddev: 0.13 stddevpct: 0.89
    iteration-id: A3E0A85E-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=16 protocol=udp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3E347BC-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3E3F996-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814886207 end: 1623814976503
        sample-id: A3E71266-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3E7BD06-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815044515 end: 1623815134809
        sample-id: A3EACAD2-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3EB8062-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815207926 end: 1623815297218
        result: (transactions-sec) samples: 41440.00 42130.00 46630.00 mean: 43400.00 stddev: 2818.46 stddevpct: 6.49
    iteration-id: A3FDCC40-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=udp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A40853A4-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A40905F6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623816149186 end: 1623816239478
        sample-id: A400ADE8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A4015B26-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815834768 end: 1623815925068
        sample-id: A4046B18-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A40523E6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623815991972 end: 1623816081260
        result: (transactions-sec) samples: 34730.00 41610.00 38240.00 mean: 38193.33 stddev: 3440.24 stddevpct: 9.01
    iteration-id: A2C3104C-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=tcp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A2C698E8-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2C7BA34-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623804664892 end: 1623804755182
        sample-id: A2C9D328-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2CAA6FE-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623804820323 end: 1623804910613
        sample-id: A2CC9C66-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2CD4D64-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623804977669 end: 1623805067960
        result: (Gbps) samples: 1.09 1.11 1.13 mean: 1.11 stddev: 0.02 stddevpct: 1.82
    iteration-id: A2FB457A-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=tcp test-type=stream wsize=16384 
      primary-period name: measurement
      samples:
        sample-id: A2FE0D64-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A2FEED7E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807027346 end: 1623807117639
        sample-id: A3032696-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A303FC24-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807348453 end: 1623807438743
        sample-id: A300A538-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A301600E-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623807186325 end: 1623807276615
        result: (Gbps) samples: 24.52 24.53 24.53 mean: 24.53 stddev: 0.01 stddevpct: 0.02
    iteration-id: A33114E8-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=64 protocol=udp test-type=stream wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A333B572-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A33470C0-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623809467275 end: 1623809557949
        sample-id: A3361B64-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A336C8B6-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623809662651 end: 1623809752301
        sample-id: A3388516-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3397084-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623809998929 end: 1623810088989
        result: (Gbps) samples: 2.23 2.16 2.27 mean: 2.22 stddev: 0.06 stddevpct: 2.54
    iteration-id: A3C33FD0-CE59-11EB-83FC-6AB3FD9E27D1
      params: duration=90 ifname=eth0 nthreads=1 protocol=udp rsize=16384 test-type=rr wsize=64 
      primary-period name: measurement
      samples:
        sample-id: A3CDB56E-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3CE6446-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814257823 end: 1623814348116
        sample-id: A3C63276-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3C6FC1A-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623813944106 end: 1623814034399
        sample-id: A3CA10D0-CE59-11EB-83FC-6AB3FD9E27D1
          primary period-id: A3CAB990-CE59-11EB-83FC-6AB3FD9E27D1
          period range: begin: 1623814102478 end: 1623814192777
        result: (transactions-sec) samples: 10230.00 9858.00 10220.00 mean: 10102.67 stddev: 211.95 stddevpct: 2.10
</pre>
