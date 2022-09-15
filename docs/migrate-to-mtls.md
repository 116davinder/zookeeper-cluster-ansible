## Steps to Migrate to MTLS Based Configurations

Read documentation here: https://zookeeper.apache.org/doc/r3.8.0/zookeeperAdmin.html#Upgrading+existing+nonTLS+cluster

### Step 0
Generate MTLS Certs, if you are testing with vagrant then you can use below-mentioned script else read above-mentioned documenations.

[vagrant-generate-tls-certs.sh](../files/vagrant-generate-tls-certs.sh)

### Step 1
Update Following vars in ```inventory/<environment>/group_vars/all.yml```
```yaml
zookeeperSslQuorum: false
zookeeperPortUnification: "false"
zookeeperSslQuorumReloadCertFiles: "false"
zookeeperSslQuorumProtocol: "TLSv1.2"
zookeeperSslQuorumKeystorePassword: "IdontKnow"
zookeeperSslQuorumTruststorePassword: "IdontKnow"
zookeeperSslQuorumHostnameVerification: "true"
zookeeperSslHostnameVerification: "true"
zookeeperSslQuorumKeystoreLocation: "{{ zookeeperInstallDir }}/zookeeper-{{ zookeeperVersion }}/conf/keystore.jks"
zookeeperSslQuorumTruststoreLocation: "{{ zookeeperInstallDir }}/zookeeper-{{ zookeeperVersion }}/conf/truststore.jks"
zookeeperCopyFiles:
  - { src: "files/certs/keystore-{{ ansible_fqdn }}.jks", dest: "{{ zookeeperSslQuorumKeystoreLocation }}" }
  - { src: "files/certs/truststore.jks", dest: "{{ zookeeperSslQuorumTruststoreLocation }}" }

# zookeeper uncategorized settings
zookeeperAdminPortUnification: "false"

zookeeperSecureClientPort: 2182 # only defined in zoo.cfg but not used/tested
```

### Step 2
Run Ansible Migration Playbook and carefully watch Ansible logs + zookeeper logs

```bash
ansible-playbook -i inventory/<environment>/cluster.ini clusterMigrateToMtls.yml
```

### Step 3
Update Following vars in ```inventory/<environment>/group_vars/all.yml```
```yaml
zookeeperSslQuorum: true
zookeeperPortUnification: "false"
```

### Step 4
Make sure all changes are commited to your version control system.


## Knowns Issues
* Missing SAN when using IP Addresses in `zoo.cfg` instead of `fqdn`

```
javax.net.ssl.SSLPeerUnverifiedException: Certificate for <192.168.56.112> 
doesn't match any of the subject alternative names: [192.168.56.111, zookeeper1.localhost, localhost]
        at org.apache.zookeeper.common.ZKHostnameVerifier.matchIPAddress(ZKHostnameVerifier.java:197)
```
It can be fixed either by switching to FQDN settings [migrate-to-fqdn-based-configs.md](./migrate-to-fqdn-based-configs.md)
or your keystore cert must include node IP Address as SAN.