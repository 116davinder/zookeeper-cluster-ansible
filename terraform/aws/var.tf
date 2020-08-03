variable region {
  type                    = string
  default                 = "eu-central-1"
  description             = "AWS Region"
}

variable env {
  type        = string
  default     = "development"
  description = "environment name"
}

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

variable zookeeper_root_volume_size {
  type                    = number
  default                 = 10
  description             = "how much size of zookeeper root volume is required?"
}

variable zookeeper_volume_size {
  type        = number
  default     = 50
  description = "how much size of zookeeper ebs volume is required?"
}

variable zookeeper_ebs_attach_location {
  type        = string
  default     = "/dev/sdc"
  description = "disk location in linux machine"
}

variable ec2_cloudwatch_role {
  type                    = string
  default                 = "Zookeeper-CloudWatchAgentServerRole"
  description             = "aws ec2 cloudwatch role"
}