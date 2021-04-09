resource "oci_core_volume" "zookeeper-volume" {
  count               = var.zookeeper_instance_count
  availability_domain = var.instance_availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "zookeeper-volume-${count.index + 1}"
  size_in_gbs         = var.zookeeper_block_volume_size_gb
}

resource "oci_core_volume_attachment" "zookeeper_volume_attachment" {
  count           = var.zookeeper_instance_count
  attachment_type = "iscsi"
  instance_id     = element(oci_core_instance.zookeeper.*.id, count.index)
  volume_id       = element(oci_core_volume.zookeeper-volume.*.id, count.index)

  display_name                        = "zookeeper-volume-attachment-${count.index + 1}"
  is_pv_encryption_in_transit_enabled = false
  is_read_only                        = false
  use_chap                            = false
}

output "zookeeper-volume-attachment-details" {
  value = oci_core_volume_attachment.zookeeper_volume_attachment[*].id
}
