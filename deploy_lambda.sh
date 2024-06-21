#!/bin/bash

AWS_REGION="us-east-1"
LAMBDA_FUNCTION_NAME="lambda-function"
LAMBDA_HANDLER="main.lambda_function"
LAMBDA_ROLE_ARN="arn:aws:iam::992382788926:role/jenkins"  
ZIP_FILE="lambda_function.zip"  

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: No se encontró el archivo $ZIP_FILE"
    exit 1
fi

aws lambda get-function --function-name $LAMBDA_FUNCTION_NAME --region $AWS_REGION 2>/dev/null
if [ $? -ne 0 ]; then
    aws lambda create-function \
        --function-name $LAMBDA_FUNCTION_NAME \
        --runtime python3.8 \
        --role $LAMBDA_ROLE_ARN \
        --handler $LAMBDA_HANDLER \
        --zip-file fileb://$ZIP_FILE \
        --region $AWS_REGION \
        --publish
else
    aws lambda update-function-code \
        --function-name $LAMBDA_FUNCTION_NAME \
        --zip-file fileb://$ZIP_FILE \
        --region $AWS_REGION \
        --publish
fi

VERSION=$(aws lambda publish-version --function-name $LAMBDA_FUNCTION_NAME --region $AWS_REGION --query 'Version' --output text)

aws lambda update-alias \
    --function-name $LAMBDA_FUNCTION_NAME \
    --name PROD \
    --function-version $VERSION \
    --region $AWS_REGION

