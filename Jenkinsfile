pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['qa', 'dev', 'prod'], description: 'Target environment')
    booleanParam(name: 'APPLY', defaultValue: false, description: 'If true, apply changes after plan')
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Init') {
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform --version"
          sh "terraform init -input=false"
        }
      }
    }

    stage('Plan') {
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform plan -input=false -out=tfplan"
        }
      }
    }

    stage('Approve Apply') {
      when { expression { return params.APPLY == true } }
      steps {
        input message: "Apply Terraform for ${params.ENV}? (Be careful with prod)"
      }
    }

    stage('Apply') {
      when { expression { return params.APPLY == true } }
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform apply -input=false tfplan"
        }
      }
    }
  }
}