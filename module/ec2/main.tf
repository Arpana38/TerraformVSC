resource "aws_instance" "Arpanainstance1" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
#  vpc_security_group_ids = [aws_security_group.ssh.id]
#  key_name               = var.key_name

  tags = {
    Name = "TerraformInstance1"
  }
}