variable "cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = list
}

variable "private_subnet_cidr" {
  type = list
}

variable "database_subnet_cidr" {
  type = list
}

variable "tags" {
  type = map
  default = {
    Name = "vpc"
  }
}

variable "igw_tags" {
  type = map
  default = {
    Name = "igw"
  }
}

variable "public_subnet_tags" {
  type = map
  default = {
    Name = "public-subnet"
  }
}

variable "private_subnet_tags" {
  type = map
  default = {
    Name = "private-subnet"
  }
}

variable "public_route_table_tags" {
  type = map
  default = {
    Name = "public-route-table"
  }
}

variable "nat_tags" {
  type = map
  default = {
    Name = "nat"
  }
}

variable "private_route_table_tags" {
  type = map
  default = {
    Name = "private-route-table"
  }
}

variable "database_subnet_tags" {
  type = map
  default = {
    Name = "database-subnet"
  }
}

