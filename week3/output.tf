output "public_ip" {
  description = "The public ip for ssh access."
  value       = aws_instance.ec2.public_ip
}

output "rds_connection_string" {
  description = "Command to connect to the RDS instance."
  value       = "mysql --host=${aws_db_instance.rds.address} --user=ivan --password=${random_password.password.result} ${var.rds_dbname}"
  sensitive   = true
}
