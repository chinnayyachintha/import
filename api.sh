#!/bin/bash

# Function to import API Gateway REST API and associated resources
import_api_gateway_rest_api() {
  local api_id=$1
  local api_name=$2

  # Import API Gateway REST API
  terraform import aws_api_gateway_rest_api.$api_name $api_id

  # Import API Gateway Resource (/v1/token) under REST API
  terraform import aws_api_gateway_resource.v1_token_resource $api_id/root/v1/token
  
  # Import API Gateway Method (POST for /v1/token) under REST API
  terraform import aws_api_gateway_method.v1_token_post_method $api_id/v1_token_resource/POST
  
  # Import API Gateway Stage (Dev) under REST API
  terraform import aws_api_gateway_stage.dev_stage $api_id/Dev

  # Add the corresponding resource block to Terraform configuration file
  echo "resource \"aws_api_gateway_rest_api\" \"$api_name\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_resource\" \"v1_token_resource\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_method\" \"v1_token_post_method\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_stage\" \"dev_stage\" {}" >> generated_resources.tf

  echo "API Gateway REST API resources for $api_name imported and resource blocks added to generated_resources.tf."
}

# Function to import API Gateway HTTP API and associated resources
import_api_gateway_http_api() {
  local api_id=$1
  local api_name=$2

  # Import API Gateway HTTP API
  terraform import aws_api_gateway_http_api.$api_name $api_id

  # Import API Gateway Resource (/PaymentGateway_IntelysisToken) under HTTP API
  terraform import aws_api_gateway_http_api_resource.${api_name}_resource $api_id/PaymentGateway_IntelysisToken
  
  # Import API Gateway Method (ANY for /PaymentGateway_IntelysisToken) under HTTP API
  terraform import aws_api_gateway_http_api_method.${api_name}_any_method $api_id/PaymentGateway_IntelysisToken/ANY
  
  # Import API Gateway Stage (default) under HTTP API
  terraform import aws_api_gateway_http_api_stage.default_stage $api_id/default

  # Add the corresponding resource block to Terraform configuration file
  echo "resource \"aws_api_gateway_http_api\" \"$api_name\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_http_api_resource\" \"${api_name}_resource\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_http_api_method\" \"${api_name}_any_method\" {}" >> generated_resources.tf
  echo "resource \"aws_api_gateway_http_api_stage\" \"default_stage\" {}" >> generated_resources.tf

  echo "API Gateway HTTP API resources for $api_name imported and resource blocks added to generated_resources.tf."
}

# Function to import Lambda functions dynamically based on the function name and ARN
import_lambda_function() {
  local function_name=$1
  local function_arn=$2

  # Add the resource block to the Terraform configuration file (generated_resources.tf)
  echo "resource \"aws_lambda_function\" \"$function_name\" {}" >> generated_resources.tf
  echo "Terraform resource added for $function_name"

  # Attempt to import the Lambda function
  terraform import aws_lambda_function.$function_name $function_arn
  
  # Check for successful import
  if [ $? -ne 0 ]; then
    echo "Error importing $function_name with ARN $function_arn"
    exit 1
  else
    echo "Successfully imported $function_name"
  fi
}

# Main script to import resources
echo "Starting import process..."

# Import API Gateway REST API for Intelisys Payment Gateway
import_api_gateway_rest_api "3drk5yfi26" "intelisys_paymentgateway_api"

# Import API Gateway HTTP API for PaymentGateway_IntelysisToken-API
import_api_gateway_http_api "mv0roh4dqj" "PaymentGateway_IntelysisToken-API"

# Import Lambda Functions
import_lambda_function "PaymentGateway_IntelysisToken" "arn:aws:lambda:ca-central-1:017820679929:function:PaymentGateway_IntelysisToken"
import_lambda_function "PaymentGateway_Orchestrator" "arn:aws:lambda:ca-central-1:017820679929:function:PaymentGateway_Orchestrator"

echo "Import completed. Please check the generated_resources.tf for the configuration."
