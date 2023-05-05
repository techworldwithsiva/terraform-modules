# this will create VPC
# resource "aws_vpc" "this" {
#   cidr_block       = var.cidr #allowing others to override
#   instance_tenancy = "default"
# }

#These are modules belongs to company. Any number of projects in our company can use this modules

resource "aws_vpc" "this" {
  cidr_block       = var.cidr #You dont want users to create CIDR with different value
  instance_tenancy = "default"
  tags = var.tags
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id # internet gateway depends on VPC
  tags = var.igw_tags
}

resource "aws_subnet" "public" {
  #for_each = toset(local.azs)
  count = length(local.azs)
  vpc_id     = aws_vpc.this.id # it will fetch VPC ID created from above code
  cidr_block = var.public_subnet_cidr[count.index]
  tags = "${var.public_subnet_tags}"
  availability_zone = local.azs[count.index]
}

resource "aws_subnet" "private" {
  #for_each = toset(local.azs)
  count = length(local.azs)
  vpc_id     = aws_vpc.this.id # it will fetch VPC ID created from above code
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = "${var.private_subnet_tags}"
}

resource "aws_subnet" "database" {
  #for_each = toset(local.azs)
  count = length(local.azs)
  vpc_id     = aws_vpc.this.id # it will fetch VPC ID created from above code
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = "${var.private_subnet_tags}"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = var.public_route_table_tags
}

resource "aws_eip" "eip" {

}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = var.nat_tags

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" { #for private route we don't attach IGW, we attach NAT
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }

  tags = var.private_route_table_tags
}

# resource "aws_route_table_association" "public" {
#   count = length(local.azs)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "private" {
#   count = length(local.azs)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "database" {
#   count = length(local.azs)
#   subnet_id      = aws_subnet.database[count.index].id
#   route_table_id = aws_route_table.private.id
# }

