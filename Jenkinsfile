def gv

pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  parameters {
    string(name: "ECR_TAG", description: "set target ECR tag")
    booleanParam(name: "IS_DEPLOYING", defaultValue: "true", description: "Set to false to skip deployment, default true.")
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
    stage("deploy") {
      when {
        expression {
          params.IS_DEPLOYING
        }
      }
      steps {
        script {
          gv.deployToECR()
        }
      }
    }
  }
}
