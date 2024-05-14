# CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible

## 📝 Overview
The project aims to automate the infrastructure provisioning and deployment process using Terraform, Jenkins, and Ansible. It focuses on creating a pipeline to manage the infrastructure as code (IaC), configure application servers, and deploy applications efficiently.

## 🚀 Features
1. **Infrastructure Pipeline with Terraform and Jenkins**
   - Automate the provisioning of cloud resources using Terraform.
   - Integrate Terraform with Jenkins for continuous infrastructure deployment.

2. **Configuration Management with Ansible**
   - Use Ansible to configure application servers.
   - Configure Ansible to run over private IPs through a bastion for secure access.

3. **Jenkins Slave Configuration**
   - Configure EC2 instances  `(private/public)`  as Jenkins slaves to distribute workload.

4. **Deployment Pipeline**
   - Create a pipeline in Jenkins to deploy the Node.js application from a specific branch (rds_redis).

5. **Load Balancer Setup**
   - Add an application load balancer to the Terraform code to expose the Node.js application on port 80.

6. **Testing**
   - Test the application by calling specific URLs `loadbalancer_url/db` and `loadbalancer_url/redis` to ensure proper functionality.

## 📁 Directory Structure
- `Ansible/`
    - **jenkins_master role/:** Ansible role for configuring the Jenkins master node.
    - **jenkins_slave role/:** Ansible role for configuring Jenkins slave nodes.
    - **install_services.yml:** Ansible playbook to install services.
    - **inventory:** Ansible inventory file.
- `Terraform/`
    - Terraform scripts for infrastructure provisioning.
- `Jenkinsfile`
    - Jenkins script for the Terraform pipeline to provision infrastructure.
- `NodejsApp_Jenkinsfile`
    - Jenkins script for the Node.js app pipeline to deploy the app.

## 📋 Prerequisites
1. Create S3 bucket and dynamodb table on your aws account.
2. Add your bucket and dynamodb name in `Terraform/backend.tf`
   ```PYTHON
   terraform {
      backend "s3" {
        bucket         = "YOUR_BUCKET_NAME"
        key            = "terraform.tfstate"
        region         = "YOUR_REGION_NAME"
        dynamodb_table = "YOUR_TABLE_NAME"
      }
    }
   ```
3. Initialize ansible roles for a Jenkins master and slave in your terminal.
   ```
    ansible-galaxy init jenkins_master
    ansible-galaxy init jenkins_slave
   ```
4. Run your ansible playbooks using the following command:
   ```
   ansible-playbook -i inventory --private-key /PATH_TO_YOUR_PRIVATE_KEY.pem install_services.yml
   ```
5. Create 2 ec2 instances **ubuntu**  `master/public_slave` 
- Then configure in jenkins master the another ec2 to be jenkins slave (public)
    <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/a29f56a9-e4c9-4024-a596-600007a2b9d7" width="920">
6. Configure your AWS credentials on jenkins master
    <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/c524d9da-d090-4a2c-91f6-c35aba762955" width="920">

## 📷 Screenshots
### 1. Create infrastructure pipeline to run terraform with jenkins task.
- Jenkins script will be found at [Jenkinsfile](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/blob/main/Jenkinsfile).
   <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/5aa5cd0c-5d51-490b-9894-828f87bb6ddc" width="920">
   <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/ee12e303-a9a8-4de8-b2ba-15318a422109" width="920">
   <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/ee4bd83f-0d0b-4d62-9e16-1ea2a9d02276" width="920">
### 2. Configure ansible to run over private ips through bastion.
- This Ansible [inventory configuration](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/blob/main/Ansible/inventory) sets up SSH tunneling to connect to a host  `(10.0.3.156)`  in a **private network** via a **bastion** host  `(3.254.124.37)` . 
- The  `ansible_ssh_common_args`  variable specifies a ProxyCommand that establishes an SSH connection to the bastion host using a specified private key  `(../ssh-key.pem)` . 
- This configuration enables Ansible to access the target host through the bastion host
  ```
  # app private ip
  [app]
  10.0.3.156  # app private ip
  
  [app:vars]
  ansible_user = ubuntu
  ansible_ssh_private_key_file = ../ssh-key.pem
  ansible_ssh_common_args = "-o ProxyCommand=\"ssh -i ../ssh-key.pem ubuntu@3.254.124.37 -W %h:%p\""    # bastion public ip
  ```
- Run your ansible playbook using:
  ```
  ansible-playbook -i inventory --private-key ../ssh-key.pem install_services.yml
  ```
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/db89ba92-2e75-4ee4-a5f1-7097833f3131" width="920">
### 3. Write ansible script to configure ec2 to run as jenkins slaves
- Script will be found at `Ansible/jenkins_slave/tasks/main.yml` [script](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/blob/main/Ansible/jenkins_slave/tasks/main.yml)
### 4. Configure slave in jenkins dashboard (with private ip)
- Add node in jenkins master to act as a `private` jenkins slave.
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/a6673cca-da77-4e4f-aa23-689801f2b5ca" width="920">
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/3aa1596c-316c-4eed-80a1-7a2b615e6706" width="920">
- Allow Jenkins to communicate with the private agent so we open port 50000 in the firewall settings of the private network from  `manage_jenkins/security`  to allow inbound connections from the Jenkins master.
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/6d812239-77c6-42ac-9029-0daba7be3079" width="920">
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/9b970100-3186-4a7c-aec3-c78d8d44a117" width="920">
- Then connecting to the application throw bastion and run these commands:
  ```
  curl -sO http://34.251.130.27:8080/jnlpJars/agent.jar

  java -jar agent.jar -url http://34.251.130.27:8080/ -secret d3c287581abad338a03e99a441b57fb7e6237f29206bb0363dd764564a40e114 -name "aws_private_slave" -workDir "/home/ubuntu/jenkins_slave"
  ```
- Agent Connected Successfuly
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/528d7f4e-7878-45d7-b061-a0846003e0bd" width="920">
### 5. Create pipeline to deploy nodejs_example from branch (rds_redis)
- Forked repository with [Jenkinsfile](https://github.com/Nada-Khater/jenkins_nodejs_example/blob/rds_redis/Jenkinsfile) in `rds_redis` branch.
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/9a8eb6e0-16ee-40e9-8112-1e3f711a74c8" width="920">
  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/d026f563-c693-4482-88cc-196c02ce6e34" width="920">
### Some credentials needed for the node app
- To get the password of rds database run the following command
  ```
  cat jenkins_slave/workspace/Infrastructure_Pipeline/Terraform/rds_pass.txt
  ```
- To get the hostname of redis cluster run the following command
  ```
  aws elasticache describe-cache-clusters --cache-cluster-id redis-cluster --show-cache-node-info
  ```
- Configure the needed credentials to your nodejs app in jenkins master 
### 6. Add application load balancer to your terraform code to expose your nodejs app on port 80 on the load balancer
- Load balancer code added in `Terraform/load_balancer.tf` [code](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/blob/main/Terraform/load_balancer.tf)
### 7. Test your application by calling loadbalancer_url/db and /redis
- In your browser paste the load balancer link and test the app by these links:
- `http://node-alb-536757320.eu-west-1.elb.amazonaws.com/redis`

  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/2c595f7c-9ef6-4aa8-b55c-f814fcae64a3" width="920">
- `http://node-alb-536757320.eu-west-1.elb.amazonaws.com/db`

  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/3476db18-ba01-4b71-85f2-148bacec470b" width="920">
- Test the connectivity of the two databases in the private slave.

  <img src="https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/b0758613-bd6e-48b9-9a22-4ff0374620e2">

## 🛠️ Additional Tasks
### 1. Integrate slack with jenkins.
- Install slack notification plugin.
![Screenshot from 2024-05-09 12-16-32](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/2aa6d310-06fc-484a-8575-b9c8e6fbbde2)
- Create workspace.
![Screenshot from 2024-05-09 12-24-40](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/4a70252b-5c0f-498a-bd1a-3b8efd54326f)
- Add Jenkins CI.
![Screenshot from 2024-05-09 12-26-27](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/116cb6dc-21ec-47d8-94df-72fa4227c8d9)
![Screenshot from 2024-05-09 12-27-38](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/9d3bc643-45d0-4f9d-8a5f-54ad733fec75)
- Add slack credentials in jenkins.
![Screenshot from 2024-05-09 12-29-11](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/76e68c35-86ff-4702-8433-02474f1781dc)
- Configure jenkins with slack.
![Screenshot from 2024-05-09 12-32-17](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/cddb192a-b49b-4dc8-94ac-10e3196089d5)
![Screenshot from 2024-05-09 12-32-30](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/8be04bf3-2ed5-44fd-85dc-3dd9b46e817b)

### 2. Send slack message when stage in your pipeline is successful.
- Modify `declarative_pipeline` script with the folowing.
![Screenshot from 2024-05-09 12-50-34](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/75736fdb-2753-4caf-a8d0-00659c7e6e7f)
- Build the pipeline.
![Screenshot from 2024-05-09 12-52-08](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/b08fcaa5-5ac5-4a75-a3d4-dbe66a66544c)
- Note that there is a notification sent to slack with the `success` or `failure` of the pipeline.
![Screenshot from 2024-05-09 12-52-00](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/a3f8e0df-952a-4df8-b376-bf3b93224dc1)

### 3. Install audit logs plugin and test it.
- Install audit logs plugin.
![Screenshot from 2024-05-09 13-25-13](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/be7c9868-0f3b-4d09-aac0-791c92b39239)
![Screenshot from 2024-05-09 13-27-46](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/9ecdd62b-1caa-46a7-b589-71dbd1047071)
- Test it.
![Screenshot from 2024-05-09 13-27-53](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/008b4de2-c913-4384-b9d4-b7f70ece2299)

### 4. fork the following repo https://github.com/mahmoud254/Booster_CI_CD_Project and add dockerfile to run this django app and use github actions to build the docker image and push it to your dockerhub.
- Creating a `Dockerfile` after forking the repo [Dockerfile link](https://github.com/Nada-Khater/Booster_CI_CD_Project/blob/master/Dockerfile)
![Screenshot from 2024-05-09 14-38-47](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/56bbd0d1-9529-46d1-a468-0d4d80d78fc5)

- Creating `.github/workflows/docker-image.yml` in the repo [docker-image.yml link](https://github.com/Nada-Khater/Booster_CI_CD_Project/blob/master/.github/workflows/docker-image.yml)
![Screenshot from 2024-05-09 14-39-26](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/c0984e50-7f81-49fa-b119-feb3f8ed75e6)

- Add dockerHub credentials as `secrets` in the repo.
![Screenshot from 2024-05-09 14-17-52](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/733ed23d-f0ab-4dae-856a-492a62a51036)

- Build and push the image to dockerHub using `GitHub Actions`.
![Screenshot from 2024-05-09 14-37-51](https://github.com/Nada-Khater/CI-CD-Pipeline-with-Jenkins-Terraform-and-Ansible/assets/75952748/8c027715-880e-4578-8c9b-380cba6f1a1f)
