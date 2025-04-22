output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.main.id
}

output "public_subnet_ids" {
    description = "The IDs of the public subnets"
    value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
    description = "The IDs of the public subnets"
    value       = aws_subnet.private[*].id
}

output "db_subnet_ids" {
    description = "The IDs of the public subnets"
    value       = aws_subnet.private[*].id
}
output "db_subnet_group_name" {
    description = "The ID of the DB subnet group"
    value       = aws_db_subnet_group.default.name
}