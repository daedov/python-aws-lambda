pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'feature/refactor', url: 'https://github.com/daedov/python-aws-lambda'
            }
        }

        stage('Install zip') {
            steps {
                script {
                    sh 'sudo apt-get update'
                    sh 'sudo apt-get install zip'
                }
            }
        }

        stage('Prepare Zip') {
            steps {
                script {
                    sh 'zip -r lambda_function.zip main.py'
                }
            }
        }

        stage('Script Permissions') {
            steps {
                script {
                    sh 'chmod +x deploy_lambda.sh'
                }
            }
        }

        stage('Deploy Lambda') {
            steps {
                script {
                    sh './deploy_lambda.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'successfully deployed!'
        }
        failure {
            echo 'failed to deploy!'
        }
    }
}
