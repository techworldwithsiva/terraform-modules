output "vpc_id" {
  value = aws_vpc.main.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.database.name
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value = aws_subnet.public[*].id
}