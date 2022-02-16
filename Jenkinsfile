pipeline {
  agent any

  stages {

    stage("checkout") {
      
      steps {
        echo "Checking out Git repo"
      }
    }
    stage("build") {
    
      steps {
        echo "Building application"
      }
    }
    stage("test") {
      steps {
        echo "Testing applaction"
      } 
    }
    stage("deploy") {
    
      steps {
        echo "Deploying application"
      }
    }
  }
}