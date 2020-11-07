resource "aws_key_pair" "ssh_key" {
    key_name   = "paul-macbook"
    public_key = var.ssh_key
}

data "aws_ami" "bedrock" {
    most_recent = true

    filter {
        name   = "name"
        values = ["minecraft-bedrock-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["326613683507"]
}

locals {
  instance-startup = <<EOF
#!/bin/bash

sed -i '' -e 's/^difficulty.*/difficulty=normal/' /usr/local/bedrock/server.properties
cd /usr/local/bedrock
export LD_LIBRARY_PATH=.
./bedrock_server
EOF
}

resource "aws_instance" "bedrock" {
    ami           = data.aws_ami.bedrock.id
    instance_type = "t3.micro"
    key_name      = aws_key_pair.ssh_key.id
    subnet_id     = element(aws_subnet.public_subnet.*.id,0)
    vpc_security_group_ids = [aws_security_group.allow_ssh.id,aws_security_group.allow_bedrock.id]

    tags = {
        Name = "Minecraft Bedrock"
    }

    user_data_base64 = base64encode(local.instance-startup)
}