data "aws_availability_zones" "available" {}

resource "aws_vpc" "bedrock" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "bedrock"
    }
}

resource "aws_subnet" "public_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.bedrock.id
    cidr_block = "10.0.${10+count.index}.0/24"
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.bedrock.id

    tags = {
        Name = "Bedrock gateway"
    }
}

resource "aws_route" "default_route" {
    route_table_id            = aws_vpc.bedrock.default_route_table_id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow inbound traffic to SSH service"
    vpc_id      = aws_vpc.bedrock.id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ips
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_ssh"
    }
}

resource "aws_security_group" "allow_bedrock" {
    name        = "allow_bedrock"
    description = "Allow inbound traffic to Minecraft bedrock ports"
    vpc_id      = aws_vpc.bedrock.id

    ingress {
        description = "Bedrock ping"
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        cidr_blocks = var.allowed_ips
    }

    ingress {
        description = "Bedrock access1"
        from_port   = 19132
        to_port     = 19133
        protocol    = "udp"
        cidr_blocks = var.allowed_ips
    }

    ingress {
        description = "Bedrock access2"
        from_port   = 58324
        to_port     = 58324
        protocol    = "udp"
        cidr_blocks = var.allowed_ips
    }

    ingress {
        description = "Bedrock access3"
        from_port   = 60484
        to_port     = 60484
        protocol    = "udp"
        cidr_blocks = var.allowed_ips
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_bedrock"
    }
}