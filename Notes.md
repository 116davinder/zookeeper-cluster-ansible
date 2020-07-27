### how to umount ebs volume from ec2 machines with ansible
`ansible -m shell -a "umount -d /dev/xvdc" -i ../../inventory/development/cluster-aws.ini all`