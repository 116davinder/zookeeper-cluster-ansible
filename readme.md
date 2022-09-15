# Apache Zookeeper Ansible

It is group of playbooks to manage apache zookeeper.

## **Requirements**
* Download Apache Zookeeper Tar Manually ( Mandatory )
* vagrant ( Optional )
* Any OS with SystemD ( Mandatory )
* Ansible ( Mandatory )
* `netaddr` python package on ansible controller node.

## **Notes***
```
1. All tasks like jvm/logging/downgrade/removeOldVersion will be done in serial order.
```

## **Development Environment Setup**
* **STEP-1**
```
vagrant plugin install vagrant-hosts
vagrant up
```

* **STEP-2**
```
ansible-playbook -i inventory/development/cluster.ini clusterSetup.yml
```

## **Apache Zookeeper Playbooks**

### **Cloud Infra Using Terraform**

* `terraform/aws`
* `terraform/oci`

### **AWS Cloud PreSetup for cluster**
It will enable following things on all nodes.

1. `/zookeeper` mount point from ebs created by terraform.
2. Install and configure `awslogs` agent for kafka-logs.
3. Install python3 packages

* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .
* Update Required vars in ```inventory/<environment>/cluster.ini``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterAwsPreSetup.yml```

### **To start new cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .
* Update Required vars in ```inventory/<environment>/cluster.ini``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterSetup.yml```

### **Monitoring Setup**
* **To add custom metric exporter to cluster**

```ansible-playbook -i inventory/<environment>/cluster.ini clusterCustomMetricExporter.yml```

* **To add newrelic monitoring to cluster**

```ansible-playbook -i inventory/<environment>/cluster.ini clusterNewRelicSetup.yml```

### **Rolling restart cluster**

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRollingRestart.yml```

### **To update jvm/logging/zoo.cg/jaas.conf settings of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .
```bash
ansible-playbook -i inventory/<environment>/cluster.ini clusterConfigsUpdate.yml -e zookeeperConfigFile=zoo.cfg
ansible-playbook -i inventory/<environment>/cluster.ini clusterConfigsUpdate.yml -e zookeeperConfigFile=java.env
ansible-playbook -i inventory/<environment>/cluster.ini clusterConfigsUpdate.yml -e zookeeperConfigFile=jaas.conf
ansible-playbook -i inventory/<environment>/cluster.ini clusterConfigsUpdate.yml -e zookeeperConfigFile=log4j.properties
```

### **To upgrade java version of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterJava.yml```

### **To upgrade OS version of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterSystemUpgrade.yml```

### **To remove old version files of zookeeper from cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRemoveOldVersion.yml```

### **To remove zookeeper cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRemoveNodes.yml```

## **Migration Playbooks**
### [Migrate Zookeeper to FQDN based Configurations](./docs/migrate-to-fqdn-based-configs.md)
### [Migrate Zookeeper to SASL Cluster](./docs/migrate-to-sasl.md)
### [Migrate Zookeeper to MTLS Quorum Cluster](./docs/migrate-to-mtls.md)

### **Tested Zookeeper Versions**
* `3.7.1`
* `3.8.0`

### **Tested OS**
* CentOS 7
* RedHat 7
* Amzaon Linux 2
* Ubuntu 18

### **Tested Ansible Version**
```
ansible==6.1.0
ansible-core==2.13.2
```
