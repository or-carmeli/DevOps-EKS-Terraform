# DevOpsAssignment-Moveo Project

## Overview
This project outlines the setup and deployment process for the DevOpsAssignment-Moveo project, including AWS infrastructure setup using Terraform, Docker containerization, Kubernetes deployment, and public access configuration.

## Table of Contents
- [Repository Setup](#repository-setup)
- [AWS Infrastructure Setup using Terraform](#aws-infrastructure-setup-using-terraform)
- [Docker Containerization](#docker-containerization)
- [Kubernetes Deployment using Minikube](#kubernetes-deployment-using-minikube)
- [Public Access and DNS Configuration](#public-access-and-dns-configuration)
- [Configuring the EC2 Instance](#configuring-the-ec2-instance)
- [Deployment Diagrams](#deployment-diagrams)
- [Executing Terraform Code](#executing-terraform-code)
- [Launching the Application](#launching-the-application)
- [Additional Notes](#additional-notes)

## Repository Setup
Clone the repository to get started:
```bash
git clone https://github.com/or-carmeli/DevOpsAssignment-Moveo.git
cd DevOpsAssignment-Moveo
```

## AWS Infrastructure Setup using Terraform
### Prerequisites
- Install Terraform version v1.6.4 
- Configure AWS with IAM user with the appropriate permissions.
- Install Docker.
- AWS CLI.

### Terraform Resources Created
The `main.tf` file defines the following AWS resources:

- Virtual Private Cloud (VPC) with DNS hostnames enabled.
- Internet Gateway for the VPC.
- Public Route Table with routes for external internet access.
- Public Subnets in multiple availability zones with public IP mapping.
- Private Subnet without public IP mapping.
- EC2 instances for Kubernetes deployment and Bastion Host.
- Security Groups for Kubernetes nodes, Bastion Host, and Application Load Balancer (ALB).
- Application Load Balancer, Target Group, and Listener for routing external traffic.

The variables.tf file ....
The output.tf file ....

### Execution
Run Terraform commands:
```bash
terraform init
terraform plan
terraform apply
```

## Docker Containerization
### Dockerfile
Create a Dockerfile for NGINX with a custom message.

### Build and Run
```bash
docker build -t my-nginx .
docker run -d -p 80:80 my-nginx
```

## Kubernetes Deployment using Minikube
Established a Kubernetes cluster using Minikube and deployed a Dockerized NGINX application. Configured the NGINX to be assigned to port 80 on the instance using Kubernetes resources.

### Setup
Install and start Minikube.

### Kubernetes Configuration Files
Created the following Kubernetes resource files:
- `deployment.yaml`: For deploying NGINX to Kubernetes.
- `nginx-service.yaml`: To define the NGINX service.
- `nginx-ingress.yaml`: For setting up Ingress to manage external access to the services in the cluster.
- `alb-ingress-controller.yaml`: To control the AWS Application Load Balancer behavior.

## Executing the Deployment
### Committing the Configuration to Git
After creating the configuration files, add them to the Git repository and push the changes:
```bash
git add .
git commit -m "Added terraform and kubernetes configuration files"
git push
```

## Public Access and DNS Configuration
### Domain
Acquire domain of your choice.

### DNS and Route 53
Setup DNS records and Namespaces on Domain.com and AWS Route 53.

### Verification
Accessing the domain should display "yo this is nginx."

## Configuring the EC2 Instance
Configuration steps executed through SSH from the Bastion Host:

### 1. Update and Install Dependencies
Update the package list and upgrade the packages:
```bash
sudo apt-get update && sudo apt-get upgrade
```

### 2. Install Docker (Container Runtime)
Install and start Docker:
```bash
sudo apt-get install docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

### 3. Install Kubernetes Components
#### Add Kubernetes Repository
For Ubuntu/Debian:
```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```
For RHEL/CentOS:
```bash
sudo yum install -y epel-release
```

#### Install Kubernetes Components
For Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
```
For RHEL/CentOS:
```bash
sudo yum install -y kubelet kubeadm kubectl
```
Enable and start kubelet:
```bash
sudo systemctl enable kubelet && sudo systemctl start kubelet
```

## Deployment Diagrams
Include diagrams here.

## Executing Terraform Code
Navigate to the Terraform directory and execute:
```bash
terraform init
terraform plan
terraform apply
```

## Launching the Application
Ensure Minikube is running:
```bash
minikube status
```
Access the application via the domain.

## Additional Notes
- Update and review Terraform state regularly (manually/CronJob)
- Monitor Kubernetes resources (daemonSets etc Promethus and Grafana)
- Check security group rules and VPC settings.

## Contact

Example:
```
For any inquiries, please reach out to ocarmeli7@gmail.com.
```

---

© 2023 [Or Carmeli](https://github.com/or-carmeli). All Rights Reserved.
```

