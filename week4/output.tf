output "public_ip" {
  description = "The IP of the public EC2 instance."
  value       = aws_instance.public.public_ip
}

output "private_ip" {
  description = "The IP of the private EC2 instance."
  value       = aws_instance.private.private_ip
}

output "lb_url" {
  description = "Load balancer URL"
  value       = "http://${aws_lb.main.dns_name}/"
}
