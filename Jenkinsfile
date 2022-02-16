pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  parameters {
    booleanParam(name: 'IS_DEPLOYING', defaultValue: 'true', description: 'Set false to skip deployment, default true.')
  }

  stages {
    stage("build") {
    
      steps {
        sh "git submodule init"
        sh "git submodule update"
        sh "mvn install -DskipTests"
      }
    }
    stage("test") {
      steps {
        sh "mvn test"
      } 
    }
    stage("deploy") {
      when {
        expression {
          params.IS_DEPLOYING
        }
      }
      steps {
        echo "Deploying application"
      }
    }
  }
}
