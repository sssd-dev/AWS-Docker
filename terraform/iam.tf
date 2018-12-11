resource "aws_iam_instance_profile" "docker_node" {
  name = "docker_profile"
  role = "${aws_iam_role.docker_role.name}"
  depends_on = ["aws_iam_role.docker_role"]
}

resource "aws_iam_role" "docker_role" {
  name = "docker_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}