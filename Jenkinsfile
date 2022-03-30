def gv

pipeline {
  agent {
    node {
      label "worker-one"
    }
  }

  tools {
    maven 'Maven'
  }

  parameters {
    booleanParam(name: "IS_CLEANWORKSPACE", defaultValue: "true", description: "Set to false to disable folder cleanup, default true.")
    booleanParam(name: "IS_DEPLOYING", defaultValue: "true", description: "Set to false to skip deployment, default true.")
    booleanParam(name: "IS_TESTING", defaultValue: "false", description: "Set to false to skip testing, default true!")
  }

  environment {
    AWS_ACCOUNT_ID = credentials("AWS_ACCOUNT_ID")
    AWS_PROFILE = credentials("AWS_PROFILE")
    COMMIT_HASH = "${sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()}"
    DOCKER_IMAGE = "user"
    ECR_REGION = credentials("AWS_REGION")
  }

  stages {
    stage("init") {
      steps {
          script {
          gv = load "script.groovy"
        }
      }
    }
    stage("Test") {
      steps {
        script {
          gv.testApp()
        }
      } 
    }   
    stage("Package Artifact") {
      steps {
        script {
          gv.buildApp()
        }
      }
    } 
    stage("SonarQube") {
      steps {
        withSonarQubeEnv("us-west-1-sonar") {
            sh "mvn verify sonar:sonar"
        }
      }
    }
    stage("Await Quality Gate") {
      steps {
          waitForQualityGate abortPipeline: true
      }
    }
    stage("Upstream to ECR") {
      steps {
        script {
          gv.upstreamToECR()
        }
      }
    }
    stage("Fetch Environment Variables"){
      steps {
        sh "aws lambda invoke --function-name getServiceEnv data.json --profile $AWS_PROFILE"
      }
    }
    stage("Deploy to ECS"){
      environment {
        ARN_ENCRYPT_SECRET_KEY = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_ENCRYPT_SECRET_KEY"]'""", returnStdout: true).trim()}"
        ARN_JWT_SECRET_KEY = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_JWT_SECRET_KEY"]'""", returnStdout: true).trim()}"
        ARN_MYSQL_DATABASE = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_MYSQL_DATABASE"]'""", returnStdout: true).trim()}"
        ARN_MYSQL_HOST = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_MYSQL_HOST"]'""", returnStdout: true).trim()}"
        ARN_MYSQL_PASSWORD = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_MYSQL_PASSWORD"]'""", returnStdout: true).trim()}"
        ARN_MYSQL_PORT = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_MYSQL_PORT"]'""", returnStdout: true).trim()}"
        ARN_MYSQL_USER = "${sh(script: """cat data.json | jq -r '.["body"]["ARN_MYSQL_USER"]'""", returnStdout: true).trim()}"
        APP_PORT = "${sh(script: """cat data.json | jq -r '.["body"]["APP_PORT"]'""", returnStdout: true).trim()}"
        CLUSTER = "${sh(script: """cat data.json | jq -r '.["body"]["CLUSTER"]'""", returnStdout: true).trim()}"
        LOAD_BALANCER = "${sh(script: """cat data.json | jq -r '.["body"]["LOAD_BALANCER"]'""", returnStdout: true).trim()}"
        SG_PRIVATE = "${sh(script: """cat data.json | jq -r '.["body"]["SG_PRIVATE"]'""", returnStdout: true).trim()}"
        SUBNET_ONE = "${sh(script: """cat data.json | jq -r '.["body"]["SUBNET_ONE"]'""", returnStdout: true).trim()}"
        SUBNET_TWO = "${sh(script: """cat data.json | jq -r '.["body"]["SUBNET_TWO"]'""", returnStdout: true).trim()}"
        VPC = "${sh(script: """cat data.json | jq -r '.["body"]["VPC"]'""", returnStdout: true).trim()}"
        WAIT_TIME = "${sh(script: """cat data.json | jq -r '.["body"]["WAIT_TIME"]'""", returnStdout: true).trim()}"
      }
      steps {
        sh "docker context use prod-jd"
        sh "docker compose -p $DOCKER_IMAGE-jd up -d"
      }
    }
  }
  post {
    cleanup {
      script {
          gv.postCleanup()
        }
    }
  }
}