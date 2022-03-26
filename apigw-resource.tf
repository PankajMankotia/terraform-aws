resource "aws_api_gateway_resource" "country-rest-api" {
  rest_api_id = aws_api_gateway_rest_api.countryws.id
  parent_id   = aws_api_gateway_rest_api.countryws.root_resource_id
  path_part   = "country"
}

resource "aws_api_gateway_method" "country-rest-api-post" {
  rest_api_id      = aws_api_gateway_rest_api.countryws.id
  resource_id      = aws_api_gateway_resource.country-rest-api.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "apigw-lambda-function-post" {
  rest_api_id             = aws_api_gateway_rest_api.countryws.id
  resource_id             = aws_api_gateway_resource.country-rest-api.id
  http_method             = aws_api_gateway_method.country-rest-api-post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

resource "aws_lambda_permission" "countryws" {
  statement_id  = "AllowAPIGatewayExecution"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.countryws.execution_arn}/*"
}