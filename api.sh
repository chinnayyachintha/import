#!/bin/bash

# Import API Gateway (REST API) - intelisys_paymentgateway_api
terraform import aws_api_gateway_rest_api.intelisys_paymentgateway_api 3drk5yfi26

# Import API Gateway Resource (/v1/token) - intelisys_paymentgateway_api
terraform import aws_api_gateway_resource.v1_token_resource 3drk5yfi26/root/v1/token

# Import API Gateway Method (POST for /v1/token) - intelisys_paymentgateway_api
terraform import aws_api_gateway_method.v1_token_post_method 3drk5yfi26/v1_token_resource/POST

# Import API Gateway Stage (Dev) - intelisys_paymentgateway_api
terraform import aws_api_gateway_stage.dev_stage 3drk5yfi26/Dev

# Import API Gateway (HTTP API) - PaymentGateway_IntelysisToken-API
terraform import aws_api_gateway_http_api.paymentgateway_intelysis_token_api mv0roh4dqj

# Import API Gateway Resource (/PaymentGateway_IntelysisToken) - PaymentGateway_IntelysisToken-API
terraform import aws_api_gateway_http_api_resource.paymentgateway_intelysis_token_resource mv0roh4dqj/PaymentGateway_IntelysisToken

# Import API Gateway Method (ANY for /PaymentGateway_IntelysisToken) - PaymentGateway_IntelysisToken-API
terraform import aws_api_gateway_http_api_method.paymentgateway_intelysis_token_any_method mv0roh4dqj/PaymentGateway_IntelysisToken/ANY

# Import API Gateway Stage (default) - PaymentGateway_IntelysisToken-API
terraform import aws_api_gateway_http_api_stage.default_stage mv0roh4dqj/default

# Import Lambda Function - PaymentGateway_IntelysisToken
terraform import aws_lambda_function.paymentgateway_intelysis_token_lambda PaymentGateway_IntelysisToken

echo "Import completed. Please check the output above."
