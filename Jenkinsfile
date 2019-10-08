pipeline {
    agent any
    stages {
        stage('fetch_latest_code') {
            steps {
                git branch: "master" , url: "https://github.com/lcamarda/terraform-jenkins.git"
            }
        }
        stage('init_and_plan') {
            steps {
                sh '''
                cd terraform
                ls -la
                rm -f myplan terraform.tfstate terraform.tfstate.backup
                terraform init
                terraform plan -out ./myplan
                '''                   
            }
        } 
        stage('terraform_apply') {
            steps {
                input message: "Should we apply the Terraform configuration?"
                sh '''
                cd terraform
                terraform apply -auto-approve ./myplan
                '''
            }
        }
        stage('terraform_destroy') {
            steps {
                input message: "Should we destroy the environment?"
                sh '''
                cd terraform
                terraform destroy -target=vsphere_virtual_machine.webvm -auto-approve
                sleep 60
                terraform destroy -auto-approve
                '''
            }
        }
    
   }
}

