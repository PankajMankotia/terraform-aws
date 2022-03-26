data "archive_file" "eventnotification-zip" {
  type        = "zip"
  source_file = "src/s3eventnotification.py"
  output_path = "dist/s3eventnotification.zip"
}

resource "aws_lambda_function" "event_notification_lambda" {
  # filename      = "s3eventnotification.zip"
  function_name    = "s3-event-notification"
  filename         = data.archive_file.eventnotification-zip.output_path
  source_code_hash = data.archive_file.eventnotification-zip.output_base64sha256
  handler          = "s3eventnotification.eventnotificationhandler"
  runtime          = "python3.8"
  memory_size      = 512
  timeout          = 6
  role             = aws_iam_role.iam_for_lambda_s3.arn

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash = filebase64sha256("s3eventnotification.zip")

  tags = local.common_tags

}