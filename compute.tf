resource "aws_key_pair" "ssh_key" {
    key_name   = "paul-macbook"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDv7vU311oCzK8nDDlvFfrAFnNd6BGz2uJJDEW8WBrLdelPHBvHCmfZdJtuT2e+yCCzldC5tFseDhZCBY6j6qFTwkngBu+a5ZH8IHD8QvTCqLPy5PUpKqTJZYmbvCGN+1s2qSRqFrishpqn1WLn3h3Ov14MItTVrdKgapZ2W80TdeSX9wlmnKsq8eTuDSew7TGwYENv1sYGOzNgR5djSeJeqFFTB2+jH5MUlzNUetLXuGHqTNsIjuw1WR/Prwc7b90VlBB29XSX8OpT6DPeVJ/2fpqJLI3+t13WOBg5rIJkhb/hSnv8eSDpTG62mj30iUNvpIiwTjTD5oE4sUpbO7d9"
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