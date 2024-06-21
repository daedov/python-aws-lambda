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
            echo 'Despliegue exitoso!'
        }
        failure {
            echo 'El despliegue ha fallado.'
        }
    }
}
