resource "aws_ebs_volume" "zookeeper" {
  count             = var.zookeeper_nodes
  availability_zone = data.aws_availability_zones.available.names[ count.index ]
  size              = var.zookeeper_volume_size

  tags = {
    Name = "zookeeper-vol-${count.index}"
  }

}