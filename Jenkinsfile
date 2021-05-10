pipeline {
  agent any

  environment {
    REGISTRY = '003235076673.dkr.ecr.eu-west-2.amazonaws.com'
    REGION = 'eu-west-2'
    ECR_REPOSITORY = 'application-test-ecr'
    VERSION = 'latest'
    CREDENTIALS = 'AWS_CREDENTIALS'
    DOCKERFILE_PATH = './app/'
    GRAFANA_USERNAME="GRAFANA_USERNAME"
    GRAFANA_PASSOWRD="GRAFANA_PASSOWRD"
  }


  stages {
    stage('Git cloning'){
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

    stage('Deploy application') {
      steps {
        sh "aws eks --region eu-west-2 update-kubeconfig --name terraform-eks-test"
        sh "kubectl apply -f deployment/test-application.yaml"
        }
      }
      
    stage('Deploy prometheus') {
      sh "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts"
      sh "helm repo update"
      sh "helm install helm-prometheus prometheus-community/prometheus --values deployment/prometheus-values.yaml"
    }

    stage('Deploy grafana') {
      sh "helm repo add grafana https://grafana.github.io/helm-charts"
      sh "helm repo update"
      sh "helm install helm-grafana grafana/grafana --set adminUser=${GRAFANA_USERNAME},adminPassword=${GRAFANA_PASSWORD} --values deployment/grafana-values.yaml"
    }
    }

  }

  post {
    success {
      sh "echo Successfully created infrastructure, builded docker image and pushed it to the ${ECR_REPOSITORY} ECR!" 
    }
    failure {
      sh "echo Failure!"
    }
  }

