# Crucible runfile
The Crucible configuration runfile (a.k.a "all-in-one JSON file", is
the JSON config file that rules the entire test, including benchmark
parameters, endpoints, tools, etc. This simplifies user input and
configuration in one single place, and therefore, enables users to
run benchmarks in Crucible by configuring all the aspects of the test
in the same JSON file. For example, to test `oslat` with Crucible
using one single JSON config, run:

```
crucible run --from-file oslat-k8s-runfile.json
```

## Naming standards
When adding examples to this directory, create the benchmark sub-dir
(if it does not exist) and Name the Crucible runfile as follows:
    `<benchmark-name>`/`<benchmark-name>`-`<endpoint>`-runfile.json
For example:
    `oslat`/`oslat`-`remotehosts`-runfile.json

## JSON schema
The config runfile structure is the following:
```
{
    "mv-params": {
    },
    "tool-params": [
    ],
    "tags": {
    },
    "endpoints": [
    ],
    "run-params": {
    }
}
```
where:
 - `mv-params`: benchmark specific params
 - `tool-params`: performance tool params, e.g. perf, sysstat, procstat, etc.
 - `tags`: tags to identify the test run in the form of "key":"value"
 - `endpoints`: endpoint definitions and configuration settings
 - `run-params`: addtional (optional) command line params, e.g. number of samples

The general schema can be found at:
https://github.com/perftool-incubator/rickshaw/blob/master/util/JSON/schema.json

And the specific endpoint blocks are validated with their respective schemas.
For example, a k8s endpoint is validated against the `schema-k8s.json` file,
available at https://github.com/perftool-incubator/rickshaw/blob/master/util/JSON/schema-k8s.json.

The blockbreaker utility can be used to validate configs and extract parts from a
JSON config run-file:  
  https://github.com/perftool-incubator/rickshaw/tree/master/util#readme

To exctract the `mv-params` block, run:
```
python3 blockbreaker.py --json run-file.json --config mv-params
```

To run local tests with the examples, see:
  https://github.com/perftool-incubator/rickshaw/tree/master/util/tests

You can import the blockbreaker module from another python code, as follows:
```
import blockbreaker
```

By importing blockbreaker you can manipulate the runfile JSON whenever you need.

