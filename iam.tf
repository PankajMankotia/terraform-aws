data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "api-gw-role" {
  statement {
    sid = "AllowDEvelopmentAccess"
    actions = [
      "lambda:*",
      "logs:*",
      "s3:*",
      "iam:*",
      "dynamodb:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_tf_lambda"
  tags               = local.common_tags
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role.json
}

resource "aws_iam_policy" "iam_for_lambda" {
  name   = "iam_tf_lambda"
  tags   = local.common_tags
  policy = data.aws_iam_policy_document.api-gw-role.json
}

resource "aws_iam_role_policy_attachment" "api-gw" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_for_lambda.arn
}


data "aws_iam_policy_document" "s3event-notification" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3event-notification-policy" {
  statement {
    sid = "AllowDEvelopmentAccess"
    actions = [
      "lambda:*",
      "logs:*",
      "s3:*",
      "iam:*",
      "dynamodb:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "iam_for_lambda_s3" {
  name               = "iam_tf_lambda_s3_eventnotification"
  tags               = local.common_tags
  assume_role_policy = data.aws_iam_policy_document.s3event-notification.json
}

resource "aws_iam_policy" "iam_for_lambda_s3" {
  name   = "iam_tf_lambda_s3_eventnotification"
  tags   = local.common_tags
  policy = data.aws_iam_policy_document.s3event-notification-policy.json
}

resource "aws_iam_role_policy_attachment" "s3_notification" {
  role       = aws_iam_role.iam_for_lambda_s3.name
  policy_arn = aws_iam_policy.iam_for_lambda_s3.arn
}