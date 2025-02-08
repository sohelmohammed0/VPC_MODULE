variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_names" {
  description = "List of VPC names to create"
  type        = list(string)
}

variable "base_cidr" {
  description = "Base CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_count" {
  description = "Number of public subnets per VPC"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets per VPC"
  type        = number
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}