resource "aws_s3_bucket_notification" "s3-event-notification" {
  bucket = aws_s3_bucket.b.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.event_notification_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.event_notification_lambda.arn
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.b.arn
  source_account = "772601752688"
}