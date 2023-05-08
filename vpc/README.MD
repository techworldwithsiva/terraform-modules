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


