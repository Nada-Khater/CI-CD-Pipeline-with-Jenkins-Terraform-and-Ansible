pipeline {
    agent { 
        label 'public_slave'
    }

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'prod'],
            description: 'Choose the environment to deploy (dev or prod)'
        )
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose the action to perform (apply or destroy)'
        )
    }
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible.git'
            }
        }
        
        stage('Run Terraform Init') {
            steps {
                script {
                    dir('Terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }
        
        stage('Run Terraform Plan') {
            steps {
                script {
                    dir('Terraform') {
                        VAR_FILE = params.ENV == 'dev' ? 'dev.tfvars' : 'prod.tfvars'
                        sh "terraform plan -var-file=${VAR_FILE}"
                    }
                }
            }
        }

        // Check if workspace exists, if not create it
        stage('Check Terraform Workspace') {
            steps {
                script {
                    dir('Terraform') {
                        def workspaceExists = sh(script: "terraform workspace list | grep ${params.ENV}", returnStatus: true) == 0
                        if (!workspaceExists) {
                            sh "terraform workspace new ${params.ENV}"
                        }
                    }
                }
            }
        }
        
        stage('Run Terraform Apply / Destroy') {
            steps {
                script {
                    dir('Terraform') {
                        def VAR_FILE 
                        
                        switch (params.ENV) {
                            case 'dev':
                                VAR_FILE = "dev.tfvars"
                                break
                                
                            case 'prod':
                                VAR_FILE = "prod.tfvars"
                                break
                                
                            default:
                                error "Invalid environment specified"
                        }
    
                        switch (params.ACTION) {
                            case 'apply':
                                sh "terraform apply -auto-approve -var-file=${VAR_FILE}"
                                break
                                
                            case 'destroy':
                                sh "terraform destroy -auto-approve -var-file=${VAR_FILE}"
                                break
                                
                            default:
                                error "Invalid action specified"
                        }
                    }
                }
            }
        }
    }
}
