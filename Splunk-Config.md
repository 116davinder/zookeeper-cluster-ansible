# Splunk Logging Configuration

## Example

```conf
[default]
host = $HOSTNAME

[monitor:///zookeeper/zookeeper-logs/*]
disabled = false
index = kafka
sourcetype = zookeeper
crcSalt = <SOURCE>
```
