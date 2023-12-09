resource "aws_iam_role" "lambda_role" {
name   = "2191420-cohort-demo-lambda-role"
tags = var.resource_tags
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "2191420-aws-lambda-policy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 tags = var.resource_tags
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
            "Effect": "Allow",
            "Action": "codedeploy:PutLifecycleEventHookExecutionStatus",
            "Resource": "*"
        }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/CodeDeployHook_AfterAllowTestTraffic.js"
  output_path = "${path.module}/CodeDeployHook_AfterAllowTestTraffic.zip"
}

resource "aws_lambda_function" "AfterAllowTestTraffic_lambda_function" {
filename                       = "${path.module}/CodeDeployHook_AfterAllowTestTraffic.zip"
function_name                  = "CodeDeployHook_AfterAllowTestTraffic"
role                           = aws_iam_role.lambda_role.arn
handler                        = "CodeDeployHook_AfterAllowTestTraffic.handler"
runtime                        = "nodejs16.x"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
tags = var.resource_tags
}