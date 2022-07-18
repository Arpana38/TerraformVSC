data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "serverone" {
  ami           = data.aws_ami.linux.id
  instance_type = var.instance_type
  tags = {
    Name = var.server_env
  }
}

output "server_ip" {
  value = aws_instance.serverone.public_ip
}

output "server_environment" {
  value = aws_instance.serverone.tags.Name
}