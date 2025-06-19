output "instance_ip" {
  value = aws_instance.web.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.private.private_ip
}
