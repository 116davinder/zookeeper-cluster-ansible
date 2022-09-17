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

## Knowns Issues
* `zkCli.sh` warns about SASL Auth Error but stil manages to connect with `zookeeper`

```
2022-09-12 21:43:50,254 [myid:localhost:2181] - WARN  [main-SendThread(localhost:2181):o.a.z.ClientCnxn$SendThread@1157] - SASL configuration failed. Will continue connection to Zookeeper server without SASL authentication, if Zookeeper server allows it.
javax.security.auth.login.LoginException: No JAAS configuration section named 'Client' was found in specified JAAS configuration file: '/zookeeper/zookeeper/conf/jaas.conf'.
        at org.apache.zookeeper.client.ZooKeeperSaslClient.<init>(ZooKeeperSaslClient.java:189)
        at org.apache.zookeeper.ClientCnxn$SendThread.startConnect(ClientCnxn.java:1151)
        at org.apache.zookeeper.ClientCnxn$SendThread.run(ClientCnxn.java:1200)
```