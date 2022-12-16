############################## LT #############################
resource "aws_launch_template" "ap-lt-1" {
  name = "ap-lt-1"

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false

  image_id = "ami-0b0dcb5067f052a63"

  instance_type = "t2.micro"

  key_name = "Mykeypair"

  vpc_security_group_ids = ["sg-017d15bb31d040788"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "lt-tag6"
    }
  }
}

############################## ASG #############################
resource "aws_autoscaling_group" "ap-autoscaling-1" {
  name                      = "ap-autoscaling-1"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  launch_template {
    id       =  aws_launch_template.ap-lt-1.id
    version  = "$Default"
  }
#  placement_group           = aws_placement_group.test.id
#  launch_configuration      = aws_launch_configuration.foobar.name
  vpc_zone_identifier       = ["subnet-0f244242","subnet-dbb26ffa"]

  tag {
    key                 = "Name"
    value               = "ap-autoscaling-1-tag"
    propagate_at_launch = true
  }
  tag {
    key                 = "env"
    value               = "dev"
    propagate_at_launch = true
  }
  tag {
    key                 = "es"
    value               = "datadog"
    propagate_at_launch = true
  }  
  tag {
    key                 = "new"
    value               = "tag1"
    propagate_at_launch = true
  }
  tag {
    key                 = "new2"
    value               = "tag2"
    propagate_at_launch = true
  }
  tag {
    key                 = "new3"
    value               = "tag3"
    propagate_at_launch = true
  }
  tag {
    key                 = "new4"
    value               = "tag4"
    propagate_at_launch = true
  }
  tag {
    key                 = "Arpana"
    value               = "Ranjit"
    propagate_at_launch = true
  }
 tag {
    key                 = "Bisan"
    value               = "Ran"
    propagate_at_launch = true
  } 
}
