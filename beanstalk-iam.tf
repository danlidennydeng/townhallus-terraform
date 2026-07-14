//beanstalk-iam.tf
//step 9

resource "aws_iam_role" "beanstalk_service_role" {
  name = "townhallus-beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "elasticbeanstalk.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "beanstalk_managed_updates" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}


resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "townhallus-beanstalk-ec2-role"

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
}

resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_cloudwatch_logs" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
  name = "townhallus-beanstalk-ec2-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

resource "aws_iam_policy" "beanstalk_ssm_read" {
  name = "townhallus-beanstalk-ssm-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:us-east-1:*:parameter/townhallus/prod/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "beanstalk_ssm_read" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = aws_iam_policy.beanstalk_ssm_read.arn
}