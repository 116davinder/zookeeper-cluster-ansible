# Apache Zookeeper Ansible

It is group of playbooks to manage apache zookeeper.

## **Requirements**
* netaddr ( Mandatory )
* Download Apache Zookeeper Tar Manually ( Mandatory )
* vagrant ( Optional )
* Any OS with SystemD ( Mandatory )
* Ansible ( Mandatory )

## **Notes***
```
1. Installation for NetAddr Module.
   * pip install netaddr
   * https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters_ipaddr.html

2. All tasks like jvm/logging/downgrade/removeOldVersion will be done in serial order.
```

## **Development Environment Setup**
* **STEP-1**
```
vagrant up
```
* **STEP-2**

add below lines to `/etc/hosts` file in all nodes.
```
192.168.56.101 zookeeper1
192.168.56.102 zookeeper2
192.168.56.103 zookeeper3
```
* **STEP-3**
```
ansible-playbook -i inventory/development/cluster.ini clusterSetup.yml
```

## **Apache Zookeeper Playbooks**

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

### **Rolling restart cluster**

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRollingRestart.yml```

### **To add splunk monitoring to cluster**
* add splunk rpms to `files` folder.

```ansible-playbook -i inventory/<environment>/cluster.ini clusterSplunkMonitorSetup.yml```

### **To update jvm settings of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterJvmConfigs.yml```

### **To update logging settings of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterLogging.yml```

### **To upgrade java version of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterJava.yml```

### **To upgrade OS version of cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterSystemUpgrade.yml```

### **To remove old version files of zookeeper from cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRemoveOldVersion.yml```

### **To remove zookeeper from cluster**
* Update Required vars in ```inventory/<environment>/group_vars/all.yml``` .

```ansible-playbook -i inventory/<environment>/cluster.ini clusterRemoveNodes.yml```

### **Tested OS**
* CentOS 7
* RedHat 7

### **Tested Ansible Version**
```
ansible 2.7.10
  config file = None
  configured module search path = ['/home/davinderpal/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python3.6/dist-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.6.7 (default, Oct 22 2018, 11:32:17) [GCC 8.2.0]
```