# Pulumi Guide
Ref: https://www.pulumi.com/docs/get-started/aws/

Use `Pulumi IaaC` to create resources for Zookeeper in AWS and Other Cloud Provider and zookeeper being managed by Ansible.
`Not tested Code`

## How to Use for AWS?
* update your `~/.aws/credentials` file.
* export `AWS_PROFILE=<your aws profile>`.
* Run `pulumi up` in `terraform/aws` folder.

## How to Use for OCI ( Oracle Cloud )?
* set your OCI credentials.
* Run `pulumi up` in `terraform/aws` folder.

## Pulumi Tested Version
```
$ pulumi version
v2.8.2
```