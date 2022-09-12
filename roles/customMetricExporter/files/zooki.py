# Cloned from: https://github.com/116davinder/zooki

# usage: python3 zooki.py /zookeeper /zookeeper/zookeeper-logs/ dev-zookeeper false

# This script suppose to export all zookeeper metric from one node and write to file
# from where splunk/cloudwatch like tools can read it.

import requests
import shutil
from socket import gethostname
import json
import sys
import os.path
from datetime import datetime


class Zooki:
    def __init__(self):
        self.zAddr = gethostname()
        self.zPort = 8080
        try:
            self.zHttpScheme = "https://" if sys.argv[4].lower() == "true" else "http://"
        except IndexError:
            self.zHttpScheme = "http://"

        self.zHttpAddr = f"{self.zHttpScheme}{self.zAddr}:{self.zPort}/commands/"
        self.cTimeNow = str(datetime.now())

    def getStorageMetric(self):
        total, used, free = shutil.disk_usage(sys.argv[1])
        _sMetric = {
            "@timestamp": self.cTimeNow,
            "command": "disk",
            "environment": sys.argv[3],
            "totalInGB": total // (2 ** 30),
            "usedInGB": used // (2 ** 30),
            "freeInGB": free // (2 ** 30),
        }
        return json.dumps(_sMetric)

    def getZMetric(self, commandPath):
        with requests.get(self.zHttpAddr + commandPath, verify=False) as f:
            if f.status_code == 200:
                _zMetric = f.json()
                _zMetric["@timestamp"] = self.cTimeNow
                _zMetric["environment"] = sys.argv[3]
            else:
                _zMetric = {}
        return json.dumps(_zMetric)

    # json retruned by monitor is too big to be handled by splunk indexer
    # so separate function to reduce the json size
    def getMonitorMetric(self):
        with requests.get(self.zHttpAddr + "monitor", verify=False) as f:
            if f.status_code == 200:
                _MM = f.json()
                _zMetric = {
                    "@timestamp": self.cTimeNow,
                    "environment": sys.argv[3],
                    "command": _MM["command"],
                    "znode_count": _MM["znode_count"],
                    "watch_count": _MM["watch_count"],
                    "outstanding_requests": _MM["outstanding_requests"],
                    "open_file_descriptor_count": _MM["open_file_descriptor_count"],
                    "ephemerals_count": _MM["ephemerals_count"],
                    "max_latency": _MM["max_latency"],
                    "avg_latency": _MM["avg_latency"],
                    "synced_followers": _MM["synced_followers"] if "synced_followers" in _MM else 0,
                    "pending_syncs": _MM["pending_syncs"] if "pending_syncs" in _MM else 0,
                    "version": _MM["version"],
                    "quorum_size": _MM["quorum_size"] if "quorum_size" in _MM else 0,
                    "uptime": _MM["uptime"],
                }
            else:
                _zMetric = {}
        return json.dumps(_zMetric)


def main():

    commandPaths = ["connections", "leader", "watch_summary"]

    z = Zooki()
    with open(os.path.join(sys.argv[2], "disk.out"), "w") as zMetricFile:
        zMetricFile.write(z.getStorageMetric())

    for command in commandPaths:
        with open(os.path.join(sys.argv[2], command + ".out"), "w") as zMetricFile:
            zMetricFile.write(z.getZMetric(command))

    with open(os.path.join(sys.argv[2], "monitor.out"), "w") as zMetricFile:
        zMetricFile.write(z.getMonitorMetric())


main()
