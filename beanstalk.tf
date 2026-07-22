//beanstalk.tf
//step 10

resource "aws_elastic_beanstalk_application" "api" {
  name        = "townhallus-api"
  description = "Express.js API for townhallus.com"
}

resource "aws_elastic_beanstalk_environment" "api" {
  name                = "townhallus-api-prod"
  application         = aws_elastic_beanstalk_application.api.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.11.2 running Node.js 22"
  tier                = "WebServer"

  depends_on = [
    aws_iam_role_policy_attachment.beanstalk_service,
    aws_iam_role_policy_attachment.beanstalk_managed_updates,
    aws_iam_role_policy_attachment.beanstalk_web_tier,
    aws_iam_role_policy_attachment.beanstalk_cloudwatch_logs,
    aws_iam_role_policy_attachment.beanstalk_ssm_read
  ]

  # lifecycle {
  #   create_before_destroy = false
  # }
  # Destroy the old resource first, then create the new one.

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
  namespace = "aws:elasticbeanstalk:environment"
  name      = "LoadBalancerType"
  value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro"
  }

# autoscaling
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Cooldown"
    value     = "300"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "MonitoringInterval"
    value     = "1 minute"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "MeasureName"
    value     = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Statistic"
    value     = "Average"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Unit"
    value     = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "Period"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "EvaluationPeriods"
    value     = "3"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "BreachDuration"
    value     = "3"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperThreshold"
    value     = "60"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "UpperBreachScaleIncrement"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerThreshold"
    value     = "25"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name      = "LowerBreachScaleIncrement"
    value     = "-1"
  }

#mode
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "NODE_ENV"
    value     = "production"
  }

  setting {
  namespace = "aws:elbv2:loadbalancer"
  name      = "SecurityGroups"
  value     = aws_security_group.api_alb.id
 }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.api_ec2.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableDefaultEC2SecurityGroup"
    value     = "true"
  }  

  setting {
  namespace = "aws:ec2:vpc"
  name      = "VPCId"
  value     = data.aws_vpc.default.id
}

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.beanstalk.ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", data.aws_subnets.beanstalk.ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

  setting {
  namespace = "aws:elbv2:listener:443"
  name      = "ListenerEnabled"
  value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = aws_acm_certificate_validation.api.certificate_arn
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "ListenerEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }

  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "DefaultProcess"
    value     = "default"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/_elb_health"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

    setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "MONGO"
    value     = "${local.townhallus_prod_ssm_arn}/MONGO"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "JWT_SECRET"
    value     = "${local.townhallus_prod_ssm_arn}/JWT_SECRET"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "MAILTRAP_TOKEN"
    value     = "${local.townhallus_prod_ssm_arn}/MAILTRAP_TOKEN"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "IPINFO_TOKEN"
    value     = "${local.townhallus_prod_ssm_arn}/IPINFO_TOKEN"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "FRONTEND_URL"
    value     = "${local.townhallus_prod_ssm_arn}/FRONTEND_URL"
  }
}