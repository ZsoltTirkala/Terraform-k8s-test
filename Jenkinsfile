pipeline {
  agent any

  environment {
    REGISTRY = '003235076673.dkr.ecr.eu-west-2.amazonaws.com'
    REGION = 'eu-west-2'
    ECR_REPOSITORY = 'application-test-ecr'
    VERSION = 'latest'
    CREDENTIALS = 'AWS_CREDENTIALS'
    DOCKERFILE_PATH = './app/'
    GRAFANA_USERNAME = 'GRAFANA_USERNAME'
    GRAFANA_PASSWORD = 'GRAFANA_PASSWORD'
  }

  stages {
    stage('Git cloning') {
      steps {
        git branch: 'main',
            credentialsId: 'github',
            url: 'https://github.com/ZsoltTirkala/Terraform-k8s-test.git'
      }
    }

    stage('Build image and push') {
      steps {
        script {
            docker.build("${ECR_REPOSITORY}", "${DOCKERFILE_PATH}")
            docker.withRegistry("https://${REGISTRY}", "ecr:${REGION}:${CREDENTIALS}") {
            docker.image("${ECR_REPOSITORY}").push("${VERSION}")
            }
        }
      }
    }
  }
}

post {
    success {
      sh "echo Successfully created infrastructure, builded docker image and pushed it to the ${ECR_REPOSITORY} ECR!"
    }
    failure {
      sh 'echo Failure!'
    }
}
