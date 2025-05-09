resource "aws_lambda_function" "add_log_function" {
  function_name   = "add_log_function_${random_string.suffix.result}"
  runtime         = "python3.9"
  handler         = "add_log_function.handler"
  filename        = data.archive_file.add_log_function_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.add_log_function_zip.output_path)
  role            = aws_iam_role.lambda_role.arn
  memory_size     = 128
  timeout         = 10

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.log_table.name
    }
  }
}
resource "aws_lambda_permission" "api_gateway_store_log" {
  statement_id  = "AllowAPIGatewayInvoke-StoreLog"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_log_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.log_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_get_logs" {
  statement_id  = "AllowAPIGatewayInvoke-GetLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_logs_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.log_api.execution_arn}/*/*"
}

resource "aws_lambda_function" "get_logs_function" {
  function_name   = "get_logs_function_${random_string.suffix.result}"
  runtime         = "python3.9"
  handler         = "get_logs_function.handler"
  filename        = data.archive_file.get_logs_function_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.get_logs_function_zip.output_path)
  role            = aws_iam_role.lambda_role.arn
  memory_size     = 128
  timeout         = 10

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.log_table.name
    }
  }
}

data "archive_file" "add_log_function_zip" {
  type        = "zip"
  source_dir  = "./add_log_function"
  output_path = "add_log_function.zip"
}

data "archive_file" "get_logs_function_zip" {
  type        = "zip"
  source_dir  = "./get_logs_function"
  output_path = "get_logs_function.zip"
}