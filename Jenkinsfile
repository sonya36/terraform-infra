pipeline {
  agent any
  options { disableConcurrentBuilds(); timestamps() }

  environment {
    TF_IN_AUTOMATION = "true"
  }

  stages {
    stage("Select Environment") {
      steps {
        script {
          env.PLAN_ONLY = "false"

          if (env.CHANGE_ID) {
            // PR build: plan only (use dev folder)
            env.ENV_DIR = "envs/dev"
            env.PLAN_ONLY = "true"
          } else if (env.BRANCH_NAME == "develop") {
            env.ENV_DIR = "envs/dev"
          } else if (env.BRANCH_NAME.startsWith("release/")) {
            env.ENV_DIR = "envs/qa"
          } else if (env.BRANCH_NAME == "main") {
            env.ENV_DIR = "envs/prod"
          } else {
            env.ENV_DIR = "envs/dev"
            env.PLAN_ONLY = "true"
          }

          echo "BRANCH=${env.BRANCH_NAME} ENV_DIR=${env.ENV_DIR} PLAN_ONLY=${env.PLAN_ONLY}"
        }
      }
    }

    stage("Terraform fmt/validate") {
      steps {
        sh """
          cd ${ENV_DIR}
          terraform fmt -check -recursive
          terraform init -input=false
          terraform validate
        """
      }
    }

    stage("Terraform plan") {
      steps {
        sh """
          cd ${ENV_DIR}
          terraform plan -input=false -var-file=terraform.tfvars -out=tfplan
        """
        archiveArtifacts artifacts: "${ENV_DIR}/tfplan", fingerprint: true
      }
    }

    stage("Prod approval") {
      when { expression { return env.ENV_DIR == "envs/prod" && env.PLAN_ONLY != "true" } }
      steps {
        input message: "Apply Terraform to PROD?", ok: "Apply"
      }
    }

    stage("Terraform apply") {
      when { expression { return env.PLAN_ONLY != "true" } }
      steps {
        sh """
          cd ${ENV_DIR}
          terraform apply -input=false -auto-approve tfplan
        """
      }
    }
  }
}