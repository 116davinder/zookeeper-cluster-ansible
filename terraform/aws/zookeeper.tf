resource "aws_instance" "zookeeper" {
  count         = var.zookeeper_nodes

  ami           = data.aws_ami.amazon_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = element(data.aws_subnet.public_subnet.*.id, count.index)
  vpc_security_group_ids  = ["${aws_security_group.zookeeper_sg.id}"]
  
  tags = {
    Name = "zookeeper-${count.index}"
  }
  availability_zone = data.aws_availability_zones.available.names[ count.index ]
  depends_on  = [aws_security_group.zookeeper_sg]
}

resource "aws_volume_attachment" "zookeeper_ebs_attach" {
  count       = var.zookeeper_nodes
  device_name = var.zookeeper_ebs_attach_location
  volume_id   = element(aws_ebs_volume.zookeeper.*.id, count.index)
  instance_id = element(aws_instance.zookeeper.*.id, count.index)
}