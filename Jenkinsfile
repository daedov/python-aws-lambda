pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = 'us-east-1'
        LAMBDA_FUNCTION_NAME = 'lambda-function'
        LAMBDA_HANDLER = 'main.lambda_function'
        LAMBDA_ROLE_ARN = 'arn:aws:iam::992382788926:role/jenkins'
        ZIP_FILE = 'lambda_function.zip'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/daedov/python-aws-lambda'
            }
        }

        stage('Build') {
            steps {
                sh 'zip -r $ZIP_FILE .'
            }
        }

        stage('Create Lambda') {
            steps {
                script {
                    sh '''
                        aws lambda create-function \
                        --function-name $LAMBDA_FUNCTION_NAME \
                        --runtime python3.10 \
                        --role $LAMBDA_ROLE_ARN \
                        --handler $LAMBDA_HANDLER \
                        --zip-file fileb://$ZIP_FILE \
                        --region $AWS_REGION \
                        --publish
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "The Lambda function ${LAMBDA_FUNCTION_NAME} has been successfully created in the ${AWS_REGION} region."
        }
        failure {
            echo "The creation of the Lambda function failed."
        }
    }
}
