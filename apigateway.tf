# Create API Gateway
resource "aws_apigatewayv2_api" "log_api" {
  name          = "log-service-api-${random_string.suffix.result}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_methods     = ["GET","POST"]
    allow_origins = [
      "*"
    ]

  }
}


# Create the POST route for storing logs
resource "aws_apigatewayv2_route" "store_log_route" {
  api_id    = aws_apigatewayv2_api.log_api.id
  route_key = "POST /addlog"
  target    = "integrations/${aws_apigatewayv2_integration.store_log_integration.id}"
  depends_on = [
    aws_apigatewayv2_integration.store_log_integration
  ]
}

# Create the GET route for retrieving logs
resource "aws_apigatewayv2_route" "get_logs_route" {
  api_id    = aws_apigatewayv2_api.log_api.id
  route_key = "GET /getlogs"
  target    = "integrations/${aws_apigatewayv2_integration.get_logs_integration.id}"
  depends_on = [
    aws_apigatewayv2_integration.get_logs_integration
  ]
}

# Integrate the store log function with the API Gateway
resource "aws_apigatewayv2_integration" "store_log_integration" {
  api_id                = aws_apigatewayv2_api.log_api.id
  integration_uri       = aws_lambda_function.add_log_function.invoke_arn
  payload_format_version = "2.0"
  integration_type      = "AWS_PROXY"
  integration_method    = "POST"
  depends_on = [
    aws_apigatewayv2_api.log_api,
    aws_lambda_function.add_log_function
  ]
}

# Integrate the get logs function with the API Gateway
resource "aws_apigatewayv2_integration" "get_logs_integration" {
  api_id                = aws_apigatewayv2_api.log_api.id
  integration_uri       = aws_lambda_function.get_logs_function.invoke_arn
  payload_format_version = "2.0"
  integration_type      = "AWS_PROXY"
  integration_method    = "POST"
  depends_on = [
    aws_apigatewayv2_api.log_api,
    aws_lambda_function.get_logs_function
  ]
}

# Create an API Gateway deployment
resource "aws_apigatewayv2_deployment" "api_deployment" {
  api_id = aws_apigatewayv2_api.log_api.id
  triggers = {
    redeployment = jsonencode({})
  }

  depends_on = [
    aws_apigatewayv2_route.store_log_route,
    aws_apigatewayv2_route.get_logs_route,
    aws_apigatewayv2_integration.store_log_integration,
    aws_apigatewayv2_integration.get_logs_integration
  ]
}

# Create a stage for the API Gateway
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id        = aws_apigatewayv2_api.log_api.id
  name          = "prod"
  deployment_id = aws_apigatewayv2_deployment.api_deployment.id
  depends_on = [
    aws_apigatewayv2_deployment.api_deployment
  ]
}