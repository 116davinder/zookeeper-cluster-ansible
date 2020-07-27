variable vpc_id {
  type = string
  default = "vpc-0935362fca368f01f"
}

variable subnet_id {
  type = string
  default = "subnet-00f117908461e14c4"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "Instance Type"
}

variable key_name {
  type        = string
  default     = "davinder-test-terraform"
  description = "aws ec2 ssh key pair name"
}

variable zookeeper_nodes {
  type        = number
  default     = 3
  description = "how many nodes of zookeeper cluster is required?"
}

variable zookeeper_volume_size {
  type        = number
  default     = 50
  description = "how size of zookeeper ebs volume is required?"
}

variable zookeeper_ebs_attach_location {
  type        = string
  default     = "/dev/sdc"
  description = "disk location in linux machine"
}