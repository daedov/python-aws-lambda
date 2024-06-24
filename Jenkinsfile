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
        S3_BUCKET = 'bucket-lambda-fn'
        S3_KEY = "lambda_deployments/${ZIP_FILE}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'zip -r ${ZIP_FILE} .'
            }
        }

        stage('Upload to S3') {
            steps {
                sh 'aws s3 cp ${ZIP_FILE} s3://${S3_BUCKET}/${S3_KEY} --region ${AWS_REGION}'
            }
        }

        stage('Create Lambda') {
            steps {
                script {
                    def functionExists = sh(script: "aws lambda get-function --function-name ${LAMBDA_FUNCTION_NAME} --region ${AWS_REGION} 2>/dev/null", returnStatus: true) == 0
                    if (!functionExists) {
                        sh """
                        aws lambda create-function \
                            --function-name ${LAMBDA_FUNCTION_NAME} \
                            --runtime python3.10 \
                            --role ${LAMBDA_ROLE_ARN} \
                            --handler ${LAMBDA_HANDLER} \
                            --code S3Bucket=${S3_BUCKET},S3Key=${S3_KEY} \
                            --region ${AWS_REGION} \
                            --publish
                        """
                        echo "The Lambda function ${LAMBDA_FUNCTION_NAME} has been successfully created in the ${AWS_REGION} region."
                    } else {
                        echo "The Lambda function ${LAMBDA_FUNCTION_NAME} already exists."
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
