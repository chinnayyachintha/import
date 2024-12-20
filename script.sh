#!/binbash

aws lambda list-functions --query 'Functions[*].FunctionArn' --output yaml | \
awk '/^-/ {gsub(/^- /, ""); print}' | while read arn; do
  # Extract the Lambda function name from the ARN (last part after ':')
  name=$(echo "$arn" | awk -F: '{print $NF}')
  
  # Debug: Print the ARN and function name
  echo "Processing ARN: $arn"
  echo "Lambda function name: $name"

  # Add the resource block to the Terraform configuration file (main.tf)
  echo "resource \"aws_lambda_function\" \"$name\" {}" >> main.tf
  echo "Terraform resource added for $name"

  # Attempt to import the Lambda function
  terraform import aws_lambda_function.$name "$arn"
  
  # Check for successful import
  if [ $? -ne 0 ]; then
    echo "Error importing $name with ARN $arn"
    exit 1
  else
    echo "Successfully imported $name"
  fi
done

echo "All Lambda functions imported successfully."
