terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



# -----------------------
# IAM User
# -----------------------
resource "aws_iam_user" "dev_user" {
  name = "developer-user"
  path = "/"
}

# Create access key (optional)
resource "aws_iam_access_key" "dev_access" {
  user = aws_iam_user.dev_user.name
}

# -----------------------
# IAM Group
# -----------------------
resource "aws_iam_group" "dev_group" {
  name = "developers"
  path = "/"
}

# Add user to group
resource "aws_iam_user_group_membership" "dev_membership" {
  user = aws_iam_user.dev_user.name
  groups = [
    aws_iam_group.dev_group.name
  ]
}

# -----------------------
# Custom IAM Policy
# -----------------------
resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "S3ReadOnlyAccessCustom"
  description = "Custom policy to allow read-only access to all S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "group_attach" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}

# -----------------------
# Attach AWS Managed Policy
# -----------------------
resource "aws_iam_user_policy_attachment" "user_attach_admin" {
  user       = aws_iam_user.dev_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# -----------------------
# IAM Role (for EC2)
# -----------------------
resource "aws_iam_role" "ec2_role" {
  name = "EC2AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach managed policy to role
resource "aws_iam_role_policy_attachment" "role_attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# -----------------------
# Instance Profile (for EC2)
# -----------------------
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2AccessInstanceProfile"
  role = aws_iam_role.ec2_role.name
}
