resource "aws_api_gateway_rest_api" "countryws" {
  name               = "apigw-s3upload"
  description        = "A REST API to upload docuemnt into S3"
  binary_media_types = ["multipart/form-data"]

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = local.common_tags
}

resource "aws_api_gateway_deployment" "apigw-lambda-function" {
  rest_api_id = aws_api_gateway_rest_api.countryws.id
  variables = {
    config_hash = md5(join("", list(
      file("apigw.tf"),
      file("apigw-resource.tf")
    )))
  }

  depends_on = [
    aws_api_gateway_integration.apigw-lambda-function-post
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "apigw-lambda-function" {
  rest_api_id   = aws_api_gateway_rest_api.countryws.id
  stage_name    = "sandbox"
  deployment_id = aws_api_gateway_deployment.apigw-lambda-function.id
}