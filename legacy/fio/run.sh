#!/bin/bash

# remotehost to test
remote_host=foo.bar.com

# set the number of samples for your run
samples=3

# userenv to build containers using
userenv="rhubi8"

# run tags
run_tags="run-type:example,samples:${samples},userenv:${userenv},remote-host:${remote_host}"

crucible run fio \
  --mv-params mv-params.json \
  --num-samples ${samples} \
  --max-sample-failures ${samples} \
  --test-order r \
  --tags ${run_tags} \
  --endpoint remotehost,host:${remote_host},user:root,client:1,userenv:${userenv}
