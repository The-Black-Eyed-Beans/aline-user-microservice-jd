pipeline {
  agent any

  tools {
    maven 'Maven'
  }

  parameters {
    string(name: 'APP_PORT', defaultValue: '80', description: 'Set application port.')
    string(name: 'DB_HOST', description: 'Set database url.')
    string(name: 'DB_PORT', defaultValue: '3306', description: 'Set database port.')
    string(name: 'DB_NAME', description: 'Set database name.')
    string(name: 'DB_USERNAME', description: 'Set database username.')
    string(name: 'DB_PASSWORD', description: 'Set database user password.')
    string(name: 'ENCRYPT_SECRET_KEY', description: 'Set application encryption key.')
    string(name: 'JWT_SECRET_KEY', description: 'Set application encryption key.')
  }

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
