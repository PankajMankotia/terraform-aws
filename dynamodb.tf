resource "aws_dynamodb_table" "remotelocking-dynamodb-table" {
  name           = "countrydetails"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "country"

  attribute {
    name = "country"
    type = "S"
  }

  tags = local.common_tags
}