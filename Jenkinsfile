pipeline {
    agent any
    stages {
        stage('fetch_latest_code_dev') {
            when { branch 'development'
            }
            steps {
                git branch: "development" , url: "https://github.com/lcamarda/terraform-jenkins.git"
            }
        }
        stage('fetch_latest_code_prod') {
            when { branch 'production'
            }
            steps {
                git branch: "production" , url: "https://github.com/lcamarda/terraform-jenkins.git"
            }
        }
        stage('init_plan_apply_dev') {
            when { branch 'development'
            }
            steps {
                sh '''
                cd terraform
                rm -f myplan terraform.tfstate terraform.tfstate.backup
                terraform init
                terraform plan -var="nat_ip=172.16.102.10" -var="tenant_name=dev" -out ./myplan
                terraform apply -auto-approve ./myplan
                '''                   
            }
        }
        stage('init_and_plan_prod') {
            when { branch 'production'
            }
            steps {
                sh '''
                cd terraform
                rm -f myplan terraform.tfstate terraform.tfstate.backup
                terraform init
                terraform plan -var="nat_ip=172.16.102.20" -var="tenant_name=prod" -out ./myplan
                '''
            }
        } 
        stage('terraform_apply_prod') {
            steps {
                input message: "Should we apply the Terraform configuration in Production?"
                sh '''
                cd terraform
                terraform apply -auto-approve ./myplan
                '''
            }
        }
        stage('terraform_destroy_dev') {
            when { branch 'development'
            }
            steps {
                input message: "Should we destroy the test environment?"
                sh '''
                cd terraform
                terraform destroy  -var="nat_ip=172.16.102.10" -var="tenant_name=dev" -target=vsphere_virtual_machine.webvm -auto-approve
                sleep 60
                terraform destroy -var="nat_ip=172.16.102.10" -var="tenant_name=dev" -auto-approve
                '''
            }
        }
        stage('terraform_destroy_prod') {
            when { branch 'production'
            }
            steps {
                input message: "Should we destroy the prod environment?"
                sh '''
                cd terraform
                terraform destroy  -var="nat_ip=172.16.102.20" -var="tenant_name=prod" -target=vsphere_virtual_machine.webvm -auto-approve
                sleep 60
                terraform destroy -var="nat_ip=172.16.102.20" -var="tenant_name=prod" -auto-approve
                '''
            }
        }
    
   }
}

