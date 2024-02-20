# Splunk Logging Configuration

**Example**
```
[default]
host = $HOSTNAME

[monitor:///zookeeper/zookeeper-logs/*]
disabled = false
index = kafka
sourcetype = zookeeper
crcSalt = <SOURCE>
```