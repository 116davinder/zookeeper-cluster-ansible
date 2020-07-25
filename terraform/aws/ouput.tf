output public_ip {
  value       = aws_instance.zookeeper[*].public_ip
  sensitive   = false
}
