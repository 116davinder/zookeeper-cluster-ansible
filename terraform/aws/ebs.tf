resource "aws_ebs_volume" "this" {
  count             = local.create ? var.zookeeper_nodes : 0
  availability_zone = keys(var.az_subnet_mapping[count.index % local.subnet_count])[0]
  size              = var.zookeeper_volume_size
  encrypted         = true
  type              = "gp3"
  tags              = merge(local.tags, map("Name", "zookeeper-${var.env}-${count.index}"))
}