resource "aws_iam_role" "githubrole" {
  name = "rolefromgithubactions"
}
  # assume_role_policy is omitted for brevity in this example. Refer to the
  # documentation for aws_iam_role for a complete example.
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "s3.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }  


# resource "aws_iam_role_policy" "githubpolicy" {
#   name   = "policyfromgithub"
#   role   = aws_iam_role.githubrole.name
#   policy = jsonencode({
#     "Statement" = [{
#       # This policy allows software running on the EC2 instance to
#       # access the S3 API.
#       "Action" = "s3:*",
#       "Effect" = "Allow",
#       "Resource" = "*"
#     }],
#   })
# }

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.githubrole.name
  policy_arn = aws_iam_policy.policy.arn
  depends_on=[aws_iam_role.githubrole]
}

# resource "aws_instance" "ec2fromgithubrole" {
#   ami           = "ami-0e6329e222e662a52"
#   instance_type = "t2.micro"

#   # Terraform can infer from this that the instance profile must
#   # be created before the EC2 instance.
#   iam_instance_profile = aws_iam_instance_profile.example.role

#   # However, if software running in this EC2 instance needs access
#   # to the S3 API in order to boot properly, there is also a "hidden"
#   # dependency on the aws_iam_role_policy that Terraform cannot
#   # automatically infer, so it must be declared explicitly:
#   depends_on = [
#     aws_iam_role_policy.githubpolicy
#   ]
# }
