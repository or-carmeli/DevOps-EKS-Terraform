# DevOpsAssignment-Moveo Project

## Overview
This project outlines the setup and deployment process for the DevOpsAssignment-Moveo project, including AWS infrastructure setup using Terraform, Docker containerization, Kubernetes deployment, and public access configuration.

## Table of Contents
- [AWS Architecture](#AWS Architecture) 📊
- [Repository Setup](#repository-setup) 📁
- [AWS Infrastructure Setup using Terraform](#aws-infrastructure-setup-using-terraform) ⚙️
- [Docker Containerization](#docker-containerization) 🐳
- [Configuring the EC2 Instance](#configuring-the-ec2-instance) 💻
- [Kubernetes Deployment using Minikube](#kubernetes-deployment-using-minikube) 🚢
- [Public Access and DNS Configuration](#public-access-and-dns-configuration) 🌐
- [Access The Application](#access-the-application) 🔗
- [Additional Notes And Considerations](#additional-notes-and-considerations) 📝

### 📊 AWS Architecture
![AWS Architecture](https://i.ibb.co/Y325jTL/moveo-assignment-drawio.png)

## 📁 Repository Setup
Clone the repository to get started:
```bash
git clone https://github.com/or-carmeli/DevOpsAssignment-Moveo.git
cd DevOpsAssignment-Moveo
```

## ⚙️ AWS Infrastructure Setup using Terraform
### Prerequisites
- Install Terraform version v1.6.4.
- Configure AWS with IAM user with the appropriate permissions (aws configure).
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

The 'variables.tf' file declares and sets default values for variables used in The Terraform configuration.
The 'outputs.tf' defines the output variables that Terraform will display at the end of the apply phase.

### Execution
Navigate to the Terraform directory and execute:
```bash
cd terraform
terraform init # If you haven't initialized your Terraform working directory
terraform plan # To review the proposed changes
terraform apply # To apply the changes
```
## 🐳 Docker Containerization
### Dockerfile
Create a Dockerfile for NGINX with a custom message - "yo this is nginx".

### Build and Run
```bash
cd Docker
docker build -t devops-assignment:1.0.0 .
docker run -d -p 80:80 devops-assignment:1.0.0
```
### Push to Docker Hub
After creating repository in Docker Hub execute:
```bash
docker push orcarmeli/devops-assignment:1.0.0
```
## 💻 Configuring the EC2 Instance
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
```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
```

#### Install Kubernetes Components
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubectl
sudo mkdir -m 755 /etc/apt/keyrings
```

Enable and start kubelet:
```bash
sudo systemctl enable kubelet && sudo systemctl start kubelet
kubectl version --client
```

##  🚢 Kubernetes Deployment using Minikube
Established a Kubernetes cluster using Minikube and deployed a Dockerized NGINX application. 
Configured the NGINX to be assigned to port 80 on the instance using Kubernetes resources.

### Install curl and Minikube
```bash
sudo apt update
sudo apt install curl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### Start Minikube and verify Installation
```bash
start minikube
kubectl get nodes
```

### Kubernetes Configuration Files
Created the following Kubernetes resource files:
- `deployment.yaml`: For deploying NGINX to Kubernetes.
- `nginx-service.yaml`: To define the NGINX service.
- `nginx-ingress.yaml`: For setting up Ingress to manage external access to the services in the cluster.
- `alb-ingress-controller.yaml`: To control the AWS Application Load Balancer behavior.

### Deploying to Kubernetes
Apply the Kubernetes configuration files using `kubectl`:

```bash
cd kubernetes
kubectl apply -f deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-ingress.yaml
kubectl apply -f alb-ingress-controller.yaml
```

## 🌐 Public Access and DNS Configuration
### Domain
If you don't already have a domain name, you'll need to register one with a domain registrar (e.g., GoDaddy, Namecheap, Google Domains).

### Configure DNS Records
Once you have your domain and the public IP address of your application, you need to configure DNS records:
1. *Go to Your Domain Registrar's Management Console:* Log in to the website where you registered your domain name.
2. *Navigate to the DNS Management Section:* Look for a section where you can manage DNS settings.
3. *Create a DNS Record:*
- Choose "CNAME Record".
- Set the Host or Name field to your desired subdomain (like www) or @ for the root domain.
- Set the Value or Points to field to the public IP address or DNS name of your load balancer/EC2 instance.

### Wait for DNS Propagation
After setting up the DNS record, it can take anywhere from a few minutes to 48 hours for the changes to propagate throughout the internet.

### Route53 for DNS
Set Up Route 53: Use Amazon Route 53 (or another DNS service) to create a DNS record that points to your load balancer. This is how users will access your application via a domain name.

### Verify Access
Once the DNS changes have propagated:
1. *Open a Web Browser:* Navigate to the domain you configured.
2. *Check for the NGINX Welcome Page or Your Application:* If you see the expected content ("yo this is nginx"), your setup is correct.


## 🔗 Access The Application
Access the application via the domain:
http://www.devopsmoveoassignment.space/

Following these steps should enable you to set up public access to your NGINX application via a DNS name and verify its functionality.

## 📝 Additional Notes And Considerations
- Update and review Terraform state regularly (manually/CronJob).
- Security: Make sure your security groups and firewall rules allow traffic on port 80 to your Kubernetes cluster.
- DNS Propagation: Sometimes DNS changes can take a while to propagate; you can check the status using various online DNS lookup tools.
- SSL/TLS Certificate: For a production application, it's important to secure your domain with an SSL/TLS certificate. Services like AWS Certificate Manager or Let’s Encrypt can be used to obtain a certificate.
- Redundancy: For high availability, consider using multiple instances of your application and LoadBalancer settings that support failover and redundancy.
- Monitoring and Logging: Implement monitoring and logging solutions to keep track of your application's health and performance.

## 📬 Contact
```
For any inquiries, please reach out to ocarmeli7@gmail.com.

---

© 2023 [Or Carmeli](https://github.com/or-carmeli). All Rights Reserved.📜
```

