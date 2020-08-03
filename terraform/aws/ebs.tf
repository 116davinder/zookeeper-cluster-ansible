resource "aws_ebs_volume" "zookeeper" {
  count             = var.zookeeper_nodes
  availability_zone = data.aws_availability_zones.available.names[ count.index % length(data.aws_availability_zones.available.names) ]
  size              = var.zookeeper_volume_size

  tags = {
    Name = "zookeeper-${var.env}-${count.index}"
    Env  = var.env
    Owner = "Terraform"
  }

}