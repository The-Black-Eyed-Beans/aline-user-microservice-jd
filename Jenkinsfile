def gv

pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  parameters {
    booleanParam(name: "IS_CLEANWORKSPACE", defaultValue: "true", description: "Set to false to disable folder cleanup, default true.")
    booleanParam(name: "IS_DEPLOYING", defaultValue: "true", description: "Set to false to skip deployment, default true.")
    booleanParam(name: "IS_TESTING", defaultValue: "true", description: "Set to false to skip testing, default true!")
  }

  environment {
    AWS_ACCOUNT_ID = credentials("AWS-ACCOUNT-ID")
    DOCKER_IMAGE = "user-microservice"
    ECR_REGION = "us-east-1"
  }

  stages {
    stage("init") {
      steps {
          script {
          gv = load "init.groovy"
        }
      }
    }
    stage("build") {
      steps {
        script {
          gv.buildApp()
        }
      }
    }
    stage("test") {
      steps {
        script {
          gv.testApp()
        }
      } 
    }
    stage('archive') {
      steps {
        archiveArtifacts artifacts: 'user-microservice/target/*.jar', followSymlinks: false
      }
    }
    stage("deploy") {
      steps {
        script {
          gv.deployToECR()
        }
      }
    }
  }
  post {
    always {
      script {
          gv.postAlways()
        }
    }
  }
}