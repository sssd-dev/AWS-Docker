
locals {
  dckr-node-userdata = <<USERDATA
#!/bin/bash -xe

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    default-jdk \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce
docker run hello-world
USERDATA
}
resource "aws_key_pair" "docker" {
  key_name = "${var.key_name}"
  public_key = "${file("${var.key_path}")}"
}
resource "aws_launch_configuration" "dckr_web" {
  # associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.docker_node.name}"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.medium"
  name_prefix                 = "terraform-dckr"
  security_groups             = ["${aws_security_group.elb.id}"]
  key_name = "${aws_key_pair.docker.key_name}"
  user_data_base64            = "${base64encode(local.dckr-node-userdata)}"
  ebs_block_device {
    device_name = "/dev/sdg"
    volume_type = "gp2"
    volume_size = 100
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dckr" {
  desired_capacity     = "${var.count}"
  launch_configuration = "${aws_launch_configuration.dckr_web.id}"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-dckr"
  load_balancers = ["${aws_elb.dckr.name}"]
  vpc_zone_identifier = ["${aws_subnet.public-subnet.id}"]
  tag {
    key                 = "Name"
    value               = "terraform-dckr"
    propagate_at_launch = true
  }
}
resource "aws_elb" "dckr" {
  name = "terraform-asg-dckr"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets = ["${aws_subnet.public-subnet.id}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}