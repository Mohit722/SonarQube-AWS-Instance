pipeline {
    agent { label 'TERRAFORMCORE' } // Use the label of your Terraform node
    parameters {
        choice(name: 'ACTION', choices: ['Create', 'Destroy'], description: 'Select action to perform')
    }

    stages {
        
        stage('Setup AWS Credentials') {
            steps {
                // Unset any existing AWS credentials to avoid conflicts
                sh 'unset AWS_ACCESS_KEY_ID'
                sh 'unset AWS_SECRET_ACCESS_KEY'
            }
        }
        
        stage('Clone Repository') {
            steps {
                // Clone your GitHub repository
                git 'https://github.com/Mohit722/SonarQube-AWS-Instance.git' // Replace with your repository
            }
        }
        
        // Combined stage for init, validate, and plan
        stage('Terraform Setup and Plan') {
            when {
                expression { params.ACTION == 'Create' } // Run this stage only if 'Create' is selected
            }
            steps {
                dir("${WORKSPACE}") { // Change to your repo folder if necessary
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                        sh '''
                        terraform init
                        terraform validate
                        terraform plan
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'Create' } // Run this stage only if 'Create' is selected
            }
            steps {
                dir("${WORKSPACE}") { // Change to your repo folder if necessary
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
        
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'Destroy' } // Run this stage only if 'Destroy' is selected
            }
            steps {
                dir("${WORKSPACE}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
                      sh 'terraform destroy -auto-approve'
                 }
             }
         }
      }    
   }
}
