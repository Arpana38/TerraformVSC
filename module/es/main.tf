resource "aws_autoscaling_group" "es_asg_worker" {
#  count = var.asg_count["worker"]
  name  = "autoscaling-test1"

  vpc_zone_identifier = ["subnet-dbb26ffa","subnet-0f244242"]
  min_size            = "2"
  max_size            = "2"
  health_check_type   = "EC2"
  enabled_metrics     = []

  lifecycle {
    create_before_destroy = true
  }

  launch_template {
    id      = "lt-01230a894377f82df"
    version = "$Latest"
  }

  tag {
    key                 = "App"
    value               = "hello1"
    propagate_at_launch = true
  }

  tag {
    key                 = "Function"
    value               = "hello2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Creator"
    value               = "hello3"
    propagate_at_launch = true
  }
}