resource "aws_instance" "zookeeper" {
  count                   = var.zookeeper_nodes

  ami                     = data.aws_ami.amazon_ami.id
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = element(data.aws_subnet.public_subnet.*.id, count.index)
  vpc_security_group_ids  = ["${aws_security_group.zookeeper_sg.id}"]
  
  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.zookeeper_root_volume_size
  }

  tags = {
    Name                  = "zookeeper-${var.env}-${count.index}"
    Env                   = var.env
    Owner                 = "Terraform"
    Software              = "Apache Zookeeper"
  }
  
  monitoring              = false
  iam_instance_profile    = var.ec2_cloudwatch_role

  availability_zone       = data.aws_availability_zones.available.names[ count.index % length(data.aws_availability_zones.available.names) ]
  depends_on              = [aws_security_group.zookeeper_sg,aws_iam_instance_profile.Zookeeper-CloudWatchAgentServerRole-Profile]
}

resource "aws_volume_attachment" "zookeeper_ebs_attach" {
  count                   = var.zookeeper_nodes
  device_name             = var.zookeeper_ebs_attach_location
  volume_id               = element(aws_ebs_volume.zookeeper.*.id, count.index)
  instance_id             = element(aws_instance.zookeeper.*.id, count.index)
  force_detach            = true
}