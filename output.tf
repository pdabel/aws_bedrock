output "public_ips" {
    value = aws_instance.bedrock.public_ip
}