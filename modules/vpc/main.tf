resource "aws_vpc" "main" {
  for_each = toset(var.vpc_names)

  cidr_block           = cidrsubnet(var.base_cidr, 8, index(var.vpc_names, each.key))
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = each.key
  })
}

locals {
  public_subnets = flatten([
    for vpc in var.vpc_names : [
      for i in range(var.public_subnet_count) : {
        vpc_name = vpc
        cidr_block = cidrsubnet(aws_vpc.main[vpc].cidr_block, 4, i)
        az = element(var.availability_zones, i % length(var.availability_zones))
      }
    ]
  ])

  private_subnets = flatten([
    for vpc in var.vpc_names : [
      for i in range(var.private_subnet_count) : {
        vpc_name = vpc
        cidr_block = cidrsubnet(aws_vpc.main[vpc].cidr_block, 4, var.public_subnet_count + i)
        az = element(var.availability_zones, i % length(var.availability_zones))
      }
    ]
  ])
}

resource "aws_subnet" "public" {
  for_each = { for idx, subnet in local.public_subnets : "${subnet.vpc_name}-public-${idx}" => subnet }

  vpc_id            = aws_vpc.main[each.value.vpc_name].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${each.value.vpc_name}-Public-Subnet"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, subnet in local.private_subnets : "${subnet.vpc_name}-private-${idx}" => subnet }

  vpc_id            = aws_vpc.main[each.value.vpc_name].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name = "${each.value.vpc_name}-Private-Subnet"
  })
}

resource "aws_internet_gateway" "igw" {
  for_each = toset(var.vpc_names)

  vpc_id = aws_vpc.main[each.key].id

  tags = merge(var.tags, {
    Name = "${each.key}-igw"
  })
}

resource "aws_route_table" "public" {
  for_each = toset(var.vpc_names)

  vpc_id = aws_vpc.main[each.key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }

  tags = merge(var.tags, {
    Name = "${each.key}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = { for key, subnet in aws_subnet.public : key => {
    vpc_name = split("-", key)[0]
    subnet_id = subnet.id
  }}

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.public[each.value.vpc_name].id
}