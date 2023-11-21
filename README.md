Understood. In that case, you can succinctly summarize the resources created by the `main.tf` Terraform file in your README. Here's how to present it in a clear and concise way:

```markdown
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
```

## AWS Infrastructure Setup using Terraform
### Prerequisites
- Install Terraform and configure AWS with IAM user 'or2'.
- Terraform version: v1.6.4

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
### Setup
Install and start Minikube.

### Deployment
Deploy the Dockerized NGINX application and configure Kubernetes resources.

## Public Access and DNS Configuration
### Domain
Acquire the domain `http://www.devopsmoveoassignment.space/`.

### DNS and Route 53
Setup DNS records on Domain.com and AWS Route 53.

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
kubectl apply -f <filename>
```
Access the application via the domain.

## Additional Notes
- Update and review Terraform state regularly.
- Monitor Kubernetes resources.
- Check security group rules and VPC settings.

---

© 2023 [Or Carmeli](https://github.com/or-carmeli). All Rights Reserved.
```

