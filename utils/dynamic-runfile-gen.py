#!/usr/bin/python3

import json

one_json = {
    "benchmarks": [
        {
            "name": "fio",
            "ids": None,
            "mv-params": {
                "global-options": [
                    {
                        "name": "required",
                        "params": [
                            {
                                "arg": "clocksource",
                                "vals": [
                                    "gettimeofday"
                                ]
                            },
                            {
                                "arg": "ramp_time",
                                "vals": [
                                    "5s"
                                ]
                            },
                            {
                                "arg": "unlink",
                                "vals": [
                                    "1"
                                ]
                            },
                            {
                                "arg": "filename",
                                "vals": [
                                    "/tmp/fio.foo"
                                ]
                            },
                            {
                                "arg": "runtime",
                                "vals": [
                                    "300s"
                                ]
                            },
                            {
                                "arg": "time_based",
                                "vals": [
                                    "1"
                                ]
                            },
                            {
                                "arg": "norandommap",
                                "vals": [
                                    "ON"
                                ]
                            },
                            {
                                "arg": "ioengine",
                                "vals": [
                                    "sync"
                                ]
                            },
                            {
                                "arg": "size",
                                "vals": [
                                    "10M"
                                ]
                            }
                        ]
                    }
                ],
                "sets": [
                    {
                        "include": "required",
                        "params": [
                            {
                                "arg": "bs",
                                "vals": [
                                    "4K"
                                ]
                            },
                            {
                                "arg": "rw",
                                "vals": [
                                    "randread"
                                ]
                            }
                        ]
                    }
                ]
            }
        }
    ],
    "tool-params": [
        {
            "tool": "sysstat"
        },
        {
            "tool": "procstat"
        }
    ],
    "tags": {
        "run-type": "scalability",
        "scalability-type": "endpoint",
        "sub-run-type": "remotehosts-dev"
    },
    "endpoints": [],
    "run-params": {
        "num-samples": 1,
        "max-sample-failures": 1,
        "test-order": "r"
    }
}

def dump_json(obj):
    return json.dumps(obj, indent = 4, separators=(',', ': '), sort_keys = True)

def main():
    vms = [
        "10.1.2.3",
        "10.1.2.4",
        "10.1.2.5.",
    ]

    hosts = [
        "10.10.10.10"
    ]

    endpoint = {
        "type": "remotehosts",
        "settings": {
            "user": "root",
            "userenv": "rhubi-latest",
            "osruntime": "podman"
        },
        "remotes": []
    }

    remotes_per_vm=10
    client_counter = 1
    for i in range(0, remotes_per_vm):
        for vm in vms:
            remote = {
                "engines": [
                    {
                        "role": "client",
                        "ids": [
                            client_counter
                        ]
                    }
                ],
                "config": {
                    "host": vm,
                    "settings": {
                        "hypervisor-host": "hypervisor-hostname"
                    }
                }
            }
            endpoint["remotes"].append(remote)
            client_counter += 1
        

    host_remotes = []
    for host in hosts:
        remote = {
            "engines": [
                {
                    "role": "profiler"
                }
            ],
            "config": {
                "host": host
            }
        }
        endpoint["remotes"].append(remote)

    one_json["endpoints"].append(endpoint)

    one_json["tags"]["endpoint-counter"] = str(len(vms) * remotes_per_vm)
    one_json["tags"]["vms"] = str(len(vms))
    one_json["tags"]["remotes-per-vm"] = str(remotes_per_vm)

    one_json["benchmarks"][0]["ids"] = "%d-%d" % (1, client_counter-1)

    print(dump_json(one_json))
    return 0

if __name__ == "__main__":
    exit(main())
