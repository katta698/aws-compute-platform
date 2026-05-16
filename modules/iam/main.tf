resource "aws_iam_role" "ec2_role" {
  name = "${var.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = var.tags
}

resource "aws_iam_group" "app_admins" {
  name = "${var.name_prefix}-app-admins"
}

resource "aws_iam_group" "app_readonly" {
  name = "${var.name_prefix}-app-readonly"
}

resource "aws_iam_policy" "ssm_session_access" {
  name        = "${var.name_prefix}-ssm-session-access"
  description = "Allow starting SSM sessions to tagged compute platform instances."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:StartSession",
          "ssm:TerminateSession",
          "ssm:ResumeSession",
          "ssm:DescribeSessions",
          "ssm:GetConnectionStatus"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ssm:DescribeInstanceInformation"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_group_policy_attachment" "app_admins_ssm" {
  group      = aws_iam_group.app_admins.name
  policy_arn = aws_iam_policy.ssm_session_access.arn
}

resource "aws_iam_group_policy_attachment" "app_readonly_view" {
  group      = aws_iam_group.app_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
