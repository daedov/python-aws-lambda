#!/bin/bash

AWS_REGION="us-east-1"
LAMBDA_FUNCTION_NAME="my-lambda-function"
LAMBDA_HANDLER="main.lambda_function"
LAMBDA_ROLE_ARN="arn:aws:iam::992382788926:role/jenkins"  
ZIP_FILE="lambda_function.zip"  

aws lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime python3.10 \
    --role $LAMBDA_ROLE_ARN \
    --handler $LAMBDA_HANDLER \
    --zip-file fileb://$ZIP_FILE \
    --region $AWS_REGION \
    --publish

aws lambda publish-version \
    --function-name $LAMBDA_FUNCTION_NAME \
    --region $AWS_REGION

aws lambda update-alias \
    --function-name $LAMBDA_FUNCTION_NAME \
    --name PROD \
    --function-version \$LATEST \
    --region $AWS_REGION
