## Steps to Migrate to SASL Based Configurations
As of 15-09-2022, MD5 based Authentication is supported via this automation code.

### Step 0
Read documentation here: https://cwiki.apache.org/confluence/display/ZOOKEEPER/Server-Server+mutual+authentication

### Step 1
Update Following vars in ```inventory/<environment>/group_vars/all.yml```
```yaml
zookeeperQuorumAuthEnableSasl: false
zookeeperQuorumCnxnThreadsSize: 20
zookeeperQuorumUsername: "quorum"
zookeeperQuorumPassword: "IdontKnow"
```

### Step 2
Run Ansible Migration Playbook

```bash
ansible-playbook -i inventory/<environment>/cluster.ini clusterMigrateToSasLAuth.yml
```

### Step 3
Update Following vars in ```inventory/<environment>/group_vars/all.yml```
```yaml
zookeeperQuorumAuthEnableSasl: true
```

### Step 4
Make sure all changes are commited to your version control system.