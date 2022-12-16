/*resource "aws_security_group" "sg-test" {
  name        = "SG-NG"
  description = "test SG not good"
  vpc_id      = "vpc-75d93a08"

  ingress {
    description      = "test SG not good"
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["76.187.30.213/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tagsg"
  }
}*/

/*resource "aws_security_group" "sg-test-second" {
  name        = "SG-NG-second"
  description = "test SG not good"
  vpc_id      = "vpc-75d93a08"

  ingress {
    description      = "test SG not good"
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["76.187.30.213/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tagsg-second"
  }
}*/
#####################################################################################
resource "aws_security_group" "sg1" {
  name        = "${var.sg_name_one}"
#  description = "${var.project_name}-Environment. Do not Touch"
  vpc_id      = "${var.sg_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic ingress {
    for_each  = var.ingress_rules_apple
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = ingress.value["cidr_blocks"]
      description     = ingress.value["description"]
    }
  }

  tags = {
#    Name = "${var.sg_name_one}"
    Name = "${var.sg_name_one}"
  }
}

#####################################################################################
resource "aws_security_group" "sg2" {
#  name        = "${var.sg_name_two}"
  name        = "${var.sg_name_two}"      #apple
  description = "Terraform created"
  vpc_id      = "${var.sg_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic ingress {
    for_each  = var.ingress_rules_orange
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = [ingress.value["cidr_blocks"]]
      description     = ingress.value["description"]
    }
  }

  tags = {
#    Name = "${var.sg_name_two}"
    Name = "${var.sg_name_two}"
  }
}

#####################################################################################
resource "aws_security_group" "sg3" {
#  name        = "${var.sg_name_two}"
  name        = "${var.sg_name_three}"        #orange
  description = "created in console to be imported"
  vpc_id      = "${var.sg_vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic ingress {
    for_each  = var.ingress_rules_mango
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = [ingress.value["cidr_blocks"]]
      description     = ingress.value["description"]
    }
  }

  tags = {
#    Name = "${var.sg_name_two}"
    Name = "${var.sg_name_three}"
  }
}