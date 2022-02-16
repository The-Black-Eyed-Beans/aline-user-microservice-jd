pipeline {
  agent any

  stages {
    stage("build") {
    
      steps {
        sh "git submodule init"
        sh "git submodule update"
      }
    }
    stage("test") {
      steps {
        sh "mvn clean package"
      } 
    }
    stage("deploy") {
    
      steps {
        echo "Deploying application"
      }
    }
  }
}