#!/bin/bash

# Set your API Gateway ID and AWS Region
API_GATEWAY_ID="your_api_gateway_id"
AWS_REGION="us-east-1"

# Initialize Terraform (if not already done)
echo "Initializing Terraform..."
terraform init

# Create a new API file to hold all imported resources
API_FILE="api.tf"
echo "Creating $API_FILE to store imported API Gateway resources..."
echo "# API Gateway Resources" > $API_FILE

# Import the main API Gateway
echo "Creating and importing API Gateway: $API_GATEWAY_ID"
echo 'resource "aws_api_gateway_rest_api" "api_gateway" {}' >> $API_FILE
terraform import aws_api_gateway_rest_api.api_gateway "$API_GATEWAY_ID"

# Fetch all resources from the API Gateway
echo "Fetching resources for API Gateway..."
RESOURCES=$(aws apigateway get-resources --rest-api-id "$API_GATEWAY_ID" --region "$AWS_REGION" --query 'items[*].[id,path]' --output text)

# Import each resource if not already present in api.tf
echo "Importing API Gateway resources..."
while read -r RESOURCE_ID RESOURCE_PATH; do
  RESOURCE_NAME=$(echo "$RESOURCE_PATH" | sed 's/[\/{}]/_/g' | sed 's/_$//')
  
  # Check if resource block already exists
  if ! grep -q "resource \"aws_api_gateway_resource\" \"resource_$RESOURCE_NAME\"" "$API_FILE"; then
    echo "resource \"aws_api_gateway_resource\" \"resource_$RESOURCE_NAME\" {}" >> $API_FILE
    echo "Importing resource: $RESOURCE_PATH (ID: $RESOURCE_ID)"
    terraform import aws_api_gateway_resource.resource_"$RESOURCE_NAME" "$API_GATEWAY_ID/$RESOURCE_ID"
  else
    echo "Resource $RESOURCE_PATH already exists in the configuration, skipping import."
  fi
done <<< "$RESOURCES"

# Import methods (GET, POST, etc.) for each resource if not already present
echo "Importing methods for each resource..."
for RESOURCE_ID in $(echo "$RESOURCES" | awk '{print $1}'); do
  METHODS=$(aws apigateway get-resource --rest-api-id "$API_GATEWAY_ID" --resource-id "$RESOURCE_ID" --region "$AWS_REGION" --query 'resourceMethods' --output json | jq -r 'keys[]')

  for METHOD in $METHODS; do
    METHOD_NAME=$(echo "$METHOD" | tr '[:upper:]' '[:lower:]')
    
    # Check if method block already exists
    if ! grep -q "resource \"aws_api_gateway_method\" \"method_${RESOURCE_ID}_${METHOD_NAME}\"" "$API_FILE"; then
      echo "resource \"aws_api_gateway_method\" \"method_${RESOURCE_ID}_${METHOD_NAME}\" {}" >> $API_FILE
      echo "Importing method: $METHOD for resource ID: $RESOURCE_ID"
      terraform import aws_api_gateway_method.method_"$RESOURCE_ID"_"$METHOD_NAME" "$API_GATEWAY_ID/$RESOURCE_ID/$METHOD"
    else
      echo "Method $METHOD for resource ID $RESOURCE_ID already exists in the configuration, skipping import."
    fi
  done
done

# Import stages if not already present
echo "Importing stages..."
STAGES=$(aws apigateway get-stages --rest-api-id "$API_GATEWAY_ID" --region "$AWS_REGION" --query 'item[*].stageName' --output text)
for STAGE in $STAGES; do
  # Check if stage block already exists
  if ! grep -q "resource \"aws_api_gateway_stage\" \"stage_$STAGE\"" "$API_FILE"; then
    echo "Importing stage: $STAGE"
    terraform import aws_api_gateway_stage.stage_"$STAGE" "$API_GATEWAY_ID/$STAGE"
    echo "resource \"aws_api_gateway_stage\" \"stage_$STAGE\" {}" >> $API_FILE
  else
    echo "Stage $STAGE already exists in the configuration, skipping import."
  fi
done

# Import deployments if not already present
echo "Importing deployments..."
DEPLOYMENTS=$(aws apigateway get-deployments --rest-api-id "$API_GATEWAY_ID" --region "$AWS_REGION" --query 'items[*].id' --output text)
for DEPLOYMENT in $DEPLOYMENTS; do
  # Check if deployment block already exists
  if ! grep -q "resource \"aws_api_gateway_deployment\" \"deployment_$DEPLOYMENT\"" "$API_FILE"; then
    echo "Importing deployment: $DEPLOYMENT"
    terraform import aws_api_gateway_deployment.deployment_"$DEPLOYMENT" "$API_GATEWAY_ID/$DEPLOYMENT"
    echo "resource \"aws_api_gateway_deployment\" \"deployment_$DEPLOYMENT\" {}" >> $API_FILE
  else
    echo "Deployment $DEPLOYMENT already exists in the configuration, skipping import."
  fi
done

echo "All API Gateway resources, methods, stages, and deployments have been imported successfully!"
echo "The api.tf file has been created with all necessary resources."
