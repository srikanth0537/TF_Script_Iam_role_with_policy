# Creating IAM role by assume policy of accessing ec2 instance.

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
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

# Creating IAM policy to access s3 service 
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
EOF  
}

# IAM policy to attach with above IAM role.
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}


# To attach the IAM role to the ec2 instance we need instance_profile resource block, 
# To be provided as an argument in the ec2 main resource block.
resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.ec2_s3_access_role.name}"
}


# ec2 instance main resource block.
resource "aws_instance" "my-test-instance" {
  ami             = "ami-0e6329e222e662a52"
  instance_type   = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"

  depends_on = [ aws_iam_policy.policy ]
}
