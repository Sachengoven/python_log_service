# Create WAFv2 Web ACL to add protection to API Gateway
resource "aws_wafv2_web_acl" "api_gateway_waf" {
  name          = "log-api-waf-${random_string.suffix.result}"
  scope         = "REGIONAL"
  default_action {
    allow{}
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name               = "APIGatewayWAFMetric"
    sampled_requests_enabled  = false
  }
  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL","ZA"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "APIGatewayWAFRateLimit"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

}

# Associate the WAFv2 Web ACL with the API Gateway
#resource "aws_wafv2_web_acl_association" "api_gateway_waf_association" {
# resource_arn = "arn:aws:apigatewayv2:${var.aws_region}::/apis/${aws_apigatewayv2_api.log_api.id}/*"
#  web_acl_arn  = aws_wafv2_web_acl.api_gateway_waf.arn
#}