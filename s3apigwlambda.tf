data "archive_file" "lambda-zip" {
  type        = "zip"
  source_file = "src/lambda_function_payload.py"
  output_path = "dist/lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # filename      = "lambda_function_payload.zip"
  function_name    = "apigw-s3upload"
  filename         = data.archive_file.lambda-zip.output_path
  source_code_hash = data.archive_file.lambda-zip.output_base64sha256
  handler          = "lambda_function_payload.handler"
  runtime          = "python3.8"
  memory_size      = 512
  timeout          = 6
  role             = aws_iam_role.iam_for_lambda.arn

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  tags = local.common_tags

}