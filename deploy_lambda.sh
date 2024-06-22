#!/bin/bash

AWS_REGION="us-east-1"
LAMBDA_FUNCTION_NAME="lambda-function"
LAMBDA_HANDLER="main.lambda_function"
LAMBDA_ROLE_ARN="arn:aws:iam::992382788926:role/jenkins"
ZIP_FILE="lambda_function.zip"

zip -r function.zip .


aws lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime python3.8 \
    --role $LAMBDA_ROLE_ARN \
    --handler $LAMBDA_HANDLER \
    --zip-file fileb://$ZIP_FILE \
    --region $AWS_REGION \
    --publish

aws lambda update-function-code \
    --function-name $LAMBDA_FUNCTION_NAME \
    --zip-file fileb://$ZIP_FILE \
    --region $AWS_REGION \
    --publish

VERSION=$(aws lambda publish-version --function-name $LAMBDA_FUNCTION_NAME --region $AWS_REGION --query 'Version' --output text)

