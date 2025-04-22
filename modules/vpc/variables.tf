########################################################################
# Common Variables
########################################################################
variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}
variable "project" {
  description = "The project name for the VPC"
  type        = string
}
variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

########################################################################
# VPC Variables
########################################################################
variable "vpc_cidr" {
  description = "value of the VPC CIDR block"
  type        = string
}


#########################################################################
# Subnet Variables
#########################################################################
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = list(string)
}
variable "azs" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}
variable "db_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = list(string)
}

variable "enable_nat" {
  description = "Enable NAT Gateway for private subnets"
  type    = bool
  default = true
}
