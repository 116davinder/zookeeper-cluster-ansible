# Splunk Logging Configuration

**Example**
```
[default]
host = $HOSTNAME

[monitor:///zookeeper/zookeeper-logs/*.out]
disabled = false
index = kafka
sourcetype = zookeeper
crcSalt = <SOURCE>
```