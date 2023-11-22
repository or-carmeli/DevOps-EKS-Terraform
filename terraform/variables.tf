variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the first public subnet"
  default     = "10.0.3.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  default     = "10.0.4.0/24"
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  default     = "10.0.5.0/24"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-06aa3f7caf3a30282"  // Ubuntu 20.04
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  default     = "KeysForMachines"
}
