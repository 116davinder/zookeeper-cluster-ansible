resource "aws_instance" "this" {
  count = local.create ? var.zookeeper_nodes : 0

  ami                    = data.aws_ami.amazon_ami.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = values(var.az_subnet_mapping[count.index % local.subnet_count])[0]
  vpc_security_group_ids = ["${aws_security_group.this[0].id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = var.zookeeper_root_volume_size
  }

  tags = merge(
    local.tags,
    map("Name", "zookeeper-node-${var.env}-${count.index}"),
    map("ami", data.aws_ami.amazon_ami.name)
  )

  monitoring           = false
  iam_instance_profile = aws_iam_instance_profile.this[0].id

  availability_zone           = keys(var.az_subnet_mapping[count.index % local.subnet_count])[0]
  associate_public_ip_address = var.associate_public_ip_address
}

resource "aws_volume_attachment" "this" {
  count        = local.create ? var.zookeeper_nodes : 0
  device_name  = var.zookeeper_ebs_attach_location
  volume_id    = element(aws_ebs_volume.this.*.id, count.index)
  instance_id  = element(aws_instance.this.*.id, count.index)
  force_detach = true
}