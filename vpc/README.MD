### VPC MODULE
Infra Engineer usually develops nodules. Users like developers, DevOps Engineers can use these modules. Companies can enforce what to use what not to use through modules.

This module creates the following resources. As part of HA(High Availability) we select 1a and 1b AZ.

### Resources
* VPC
* Public Subnets(1a and 1b)
* Private Subnets(1a and 1b)
* Database Subnets(1a and 1b)
* Internet Gateway
* Elastic IP
* NAT Gateway(spin up in 1a)
* Public Route Table(dedicated route table for public subnets)
* Private Route Tables(dedicated route table for private subnets)
* Database Route Tables(dedicated route table for database subnets)
* Route Table associations(Route table should be associated with subnets)
* Database subnet group(a group of database subnets)

### Inputs

* vpc_cidr(Required) - User should provide VPC CIDR
* tags(Required) - User should provide tags
* vpc_tags(Optional) - User can provide vpc_tags
* azs(Required) - User should provide 2 az as list
* public_subnet_cidr(Required) - User should provide a list of 2 public subnet CIDR
* public_subnet_tags(Optional) - User can provide public subnet tags
* public_subnet_names(Required) - User should provide public subnet names same as they provided public subnet CIDR
* igw_tags(Optional) - User can provide IGW tags
* public_route_table_tags(Optional) - User can provide public route table tags
* public_route_table_name(Required) - User should provide public route table name
* private_subnet_cidr(Required) - User should provide a list of 2 private subnet CIDR
* private_subnet_tags(Optional) - User can provide private subnet tags
* private_subnet_names(Required) - User should provide private subnet names same as they provided private subnet CIDR
* igw_tags(Optional) - User can provide IGW tags
* private_route_table_tags(Optional) - User can provide private route table tags
* private_route_table_name(Required) - User should provide private route table name
* database_subnet_cidr(Required) - User should provide a list of 2 database subnet CIDR
* database_subnet_tags(Optional) - User can provide database subnet tags
* database_subnet_names(Required) - User should provide database subnet names same as they provided database subnet CIDR
* database_route_table_name(Required) - User should provide database route table name
* database_route_table_tags(Optional) - User can provide database route table tags
* database_subnet_group_tags(Optional) - User can provide database subnet group tags