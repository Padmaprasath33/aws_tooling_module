resource "aws_sns_topic" "codepipeline_manual_approval" {
  name = "codepipeline_manual_approval"
}

resource "aws_sns_topic_subscription" "codepipeline_manual_approval" {
  topic_arn = aws_sns_topic.codepipeline_manual_approval.arn
  protocol  = "email"
  endpoint  = "padmaprasath.s@cognizant.com"
}


resource "aws_sns_topic_policy" "codepipeline_manual_approval_sns_policy" {
  arn = aws_sns_topic.codepipeline_manual_approval.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.codepipeline_manual_approval.arn,
    ]

    sid = "__default_statement_ID"
  }
}