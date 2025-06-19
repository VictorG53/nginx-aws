output "instance_ip" {
  value = aws_instance.web.public_ip
}

output "instance_ip_private" {
  value = aws_instance.private.private_ip
}
