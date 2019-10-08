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
                terraform init
                terraform plan
                '''                   
            }
        } 
        stage('terraform_apply') {
            steps {
                input message: "Should we apply the Terraform configuration?"
                sh '''
                terraform apply -auto-approve
                '''
            }
        }
        stage('terraform_destroy') {
            steps {
                input message: "Should we destroy the environment?"
                sh '''
                terraform destroy -target=vsphere_virtual_machine.webvm -auto-approve
                sleep 40
                terraform destroy -auto-approve
                '''
            }
        }
    
   }
}

