def gv

pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  parameters {
    string(name: "ECR_TAG", description: "set target ECR tag")
    booleanParam(name: "IS_CLEANWORKSPACE", defaultValue: "true", description: "Set to false to disable folder cleanup, default true.")
    booleanParam(name: "IS_DEPLOYING", defaultValue: "true", description: "Set to false to skip deployment, default true.")
    booleanParam(name: "IS_TESTING", defaultValue: "true", description: "Set to false to skip testing, default true.")
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
    stage('clean-workspace') {
      steps {
        script {
          gv.cleanWorkspace()
        }
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
}
