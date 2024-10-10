# SonarQube-AWS-Instance-Terraform Setup
This repository contains a Terraform script for provisioning an EC2 instance on AWS and running SonarQube in a Docker container. It also includes a Jenkins pipeline configuration for automated deployment.

Prerequisites:

Before you begin, ensure you have the following:

- AWS Account: You need an AWS account with IAM access.
- Terraform: Installed on your local machine or on your Jenkins node.
- Jenkins: A Jenkins server set up with the necessary plugins.
- Git: To clone the repository.
- Docker: The Docker image for SonarQube will be pulled during the instance setup.

 Repository Structure

```
├── Jenkinsfile
└── terraform
    └── main.tf
```

 Terraform Configuration

The `main.tf` file contains the Terraform configuration to provision the EC2 instance and install SonarQube.

 Key Components
- Provider: Configures the AWS provider and sets the region.
- Variables: Defines variables for AMI, instance type, key pair, and security group.
- Resource: Defines the `aws_instance` resource with a provisioner that installs Docker and runs SonarQube.

 
 Jenkins Pipeline

 Jenkinsfile

The Jenkinsfile contains the pipeline script to automate the deployment process. Here is a sample pipeline configuration:


pipeline {
    agent {
        label 'TERRAFORMCORE'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/your-username/your-repository.git'
            }
        }
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
    post {
        success {
            echo 'SonarQube instance has been created successfully!'
        }
        failure {
            echo 'There was an error creating the SonarQube instance.'
        }
    }
}


 Steps to Set Up Jenkins Pipeline

1. Create a New Pipeline Job:
   - Go to your Jenkins dashboard.
   - Click on "New Item."
   - Select "Pipeline" and enter a name for your job.

2. Configure the Pipeline:
   - In the job configuration, scroll down to the "Pipeline" section.
   - Choose "Pipeline script from SCM."
   - Select "Git" and provide the repository URL (e.g., `https://github.com/your-username/your-repository.git`).

3. Add AWS Credentials:
   - Make sure your Jenkins node has AWS credentials configured (via IAM roles or Jenkins credentials).

4. Run the Pipeline:
   - Save the job configuration and click "Build Now" to run the pipeline.
   - Monitor the build logs for any issues.

 Accessing SonarQube

Once the instance is created successfully, you can access SonarQube at `http://<public-ip>:9000` using the default credentials:
- Username: `admin`
- Password: `admin`

 Troubleshooting

- If you encounter issues during the Jenkins pipeline execution, check the Jenkins logs for error messages.
- Ensure that the necessary IAM permissions are set for the Jenkins instance to interact with AWS services.

 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

