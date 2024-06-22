#!/bin/bash

AWS_REGION="us-east-1"
LAMBDA_FUNCTION_NAME="lambda-function"
LAMBDA_HANDLER="main.lambda_function"
LAMBDA_ROLE_ARN="arn:aws:iam::992382788926:role/jenkins"
ZIP_FILE="lambda_function.zip"

zip -r function.zip .

wait_until_active() {
    local status=""
    while [ "$status" != "Active" ]; do
        status=$(aws lambda get-function-configuration --function-name $LAMBDA_FUNCTION_NAME --region $AWS_REGION --query 'State' --output text)
        if [ "$status" == "Failed" ]; then
            echo "Error: La creación o actualización de la función Lambda falló."
            exit 1
        fi
        echo "Esperando a que la función Lambda esté en estado 'Active'... Estado actual: $status"
        sleep 10
    done
}

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
    wait_until_active 
else
    wait_until_active  
    aws lambda update-function-code \
        --function-name $LAMBDA_FUNCTION_NAME \
        --zip-file fileb://$ZIP_FILE \
        --region $AWS_REGION \
        --publish
    wait_until_active  
fi

VERSION=$(aws lambda publish-version --function-name $LAMBDA_FUNCTION_NAME --region $AWS_REGION --query 'Version' --output text)

aws lambda update-alias \
    --function-name $LAMBDA_FUNCTION_NAME \
    --name PROD \
    --function-version $VERSION \
    --region $AWS_REGION

echo "La función Lambda se ha desplegado y la nueva versión se ha publicado exitosamente."
