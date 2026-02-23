pipeline {
  agent any

  options {
    timestamps()
  }

  parameters {
    choice(name: 'ENV', choices: ['qa', 'dev', 'prod'], description: 'Target environment')
    choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'What to do')
  }

  environment {
    TF_IN_AUTOMATION = "true"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform Init') {
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform --version"
          // -reconfigure prevents backend mismatch issues when you change backend.tf
          sh "terraform init -input=false -reconfigure"
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform plan -input=false -out=tfplan"
        }
      }
    }

    stage('Manual Approval') {
      when {
        anyOf {
          expression { return params.ACTION == 'apply' }
          expression { return params.ACTION == 'destroy' }
        }
      }
      steps {
        input message: "Approve '${params.ACTION}' for ${params.ENV}? (This changes AWS resources.)"
      }
    }

    stage('Terraform Apply') {
      when { expression { return params.ACTION == 'apply' } }
      steps {
        dir("envs/${params.ENV}") {
          sh "terraform apply -input=false tfplan"
        }
      }
    }

    stage('Terraform Destroy') {
      when { expression { return params.ACTION == 'destroy' } }
      steps {
        dir("envs/${params.ENV}") {
          // Use plan output from earlier? For destroy we typically run direct destroy.
          sh "terraform destroy -input=false -auto-approve"
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: "envs/${params.ENV}/.terraform.lock.hcl", allowEmptyArchive: true
    }
  }
}
