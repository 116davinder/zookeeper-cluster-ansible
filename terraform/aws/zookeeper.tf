resource "aws_instance" "zookeeper" {
  count         = var.zookeeper_nodes

  ami           = data.aws_ami.amazon_ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids  = ["${aws_security_group.zookeeper_sg.id}"]
  
  tags = {
    Name = "zookeeper-${count.index}"
  }
  
  depends_on  = [aws_security_group.zookeeper_sg]
}