# create VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr #user must provide his own CIDR
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(
        var.tags,
        var.vpc_tags
  ) # we need to merge common tags and VPC tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        var.tags,
        var.igw_tags
  ) 
}

#public subnets in 1a and 1b, public route table, routes and association between subnet and route table
# here we need to create 2 subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr) #count=2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
        var.tags,
        var.public_subnet_tags,
        {"Name" = var.public_subnet_names[count.index]} # this is the unique name for each subnet
  )
}

resource "aws_route_table" "public" { # one route table for public subnets
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    var.public_route_table_tags,
    {"Name" = var.public_route_table_name}
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# associate route table with public subnets. we have 1 route table that should be associated to 2 subnets

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr) #count=2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
        var.tags,
        var.private_subnet_tags,
        {"Name" = var.private_subnet_names[count.index]} # this is the unique name for each subnet
  )
}

#here the route is NAT gateway

resource "aws_eip" "main" {
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    var.igw_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" { # one route table for public subnets
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    var.private_route_table_tags,
    {"Name" = var.private_route_table_name}
  )
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr) #count=2
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
        var.tags,
        var.database_subnet_tags,
        {"Name" = var.database_subnet_names[count.index]} # this is the unique name for each subnet
  )
}

resource "aws_route_table" "database" { # one route table for public subnets
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    var.database_route_table_tags,
    {"Name" = var.database_route_table_name}
  )
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}

resource "aws_db_subnet_group" "database" {
  name       = lookup(var.tags, "Name")
  subnet_ids = aws_subnet.database[*].id
  tags = merge(
    var.tags,
    var.database_subnet_group_tags
  )
}