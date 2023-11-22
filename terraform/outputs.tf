output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_id_1" {
  description = "The ID of the first public subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_id_2" {
  description = "The ID of the second public subnet"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_id_1" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_id_2" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.private_subnet_2.id
}

output "kubernetes_instance_id" {
  description = "The ID of the Kubernetes EC2 instance"
  value       = aws_instance.kubernetes_instance.id
}

output "bastion_host_instance_id" {
  description = "The ID of the Bastion Host instance"
  value       = aws_instance.bastion_host.id
}

output "bastion_host_public_ip" {
  description = "The public IP of the Bastion Host"
  value       = aws_instance.bastion_host.public_ip
}

output "nginx_alb_arn" {
  description = "The ARN of the NGINX Application Load Balancer"
  value       = aws_lb.nginx_alb.arn
}

output "nginx_target_group_arn" {
  description = "The ARN of the NGINX Target Group"
  value       = aws_lb_target_group.nginx_target_group.arn
}

output "nginx_listener_arn" {
  description = "The ARN of the NGINX Listener"
  value       = aws_lb_listener.nginx_listener.arn
}
