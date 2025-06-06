
variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "aws-region" {
  type        = string
  description = "AWS region"
}

variable "vpc-cidr-block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc-name" {
  type        = string
  description = "Name of the VPC"
}

variable "igw-name" {
  type        = string
  description = "Name of the Internet Gateway"
}

variable "pub-subnet-count" {
  type        = number
  description = "Number of public subnets"
}

variable "pub-cidr-block" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "pub-availability-zone" {
  type        = list(string)
  description = "Availability zones for public subnets"
}

variable "pub-sub-name" {
  type        = string
  description = "Name prefix for public subnets"
}

variable "pri-subnet-count" {
  type        = number
  description = "Number of private subnets"
}

variable "pri-cidr-block" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "pri-availability-zone" {
  type        = list(string)
  description = "Availability zones for private subnets"
}

variable "pri-sub-name" {
  type        = string
  description = "Name prefix for private subnets"
}

variable "public-rt-name" {
  type        = string
  description = "Name of the public route table"
}

variable "private-rt-name" {
  type        = string
  description = "Name of the private route table"
}

variable "eip-name" {
  type        = string
  description = "Name of the Elastic IP for NAT Gateway"
}

variable "ngw-name" {
  type        = string
  description = "Name of the NAT Gateway"
}

variable "eks-sg" {
  type        = string
  description = "Name of the EKS security group"
}

variable "is-eks-cluster-enabled" {
  type        = bool
  description = "Enable or disable EKS cluster creation"
}

variable "cluster-version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
}

variable "cluster-name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "endpoint-private-access" {
  type        = bool
  description = "Enable private endpoint access for the EKS cluster"
}

variable "endpoint-public-access" {
  type        = bool
  description = "Enable public endpoint access for the EKS cluster"
}

variable "ondemand_instance_types" {
  type        = list(string)
  description = "Instance types for on-demand node group"
}

variable "spot_instance_types" {
  type        = list(string)
  description = "Instance types for spot node group"
}

variable "desired_capacity_on_demand" {
  type        = string
  description = "Desired capacity for on-demand node group"
}

variable "min_capacity_on_demand" {
  type        = string
  description = "Minimum capacity for on-demand node group"
}

variable "max_capacity_on_demand" {
  type        = string
  description = "Maximum capacity for on-demand node group"
}

variable "desired_capacity_spot" {
  type        = string
  description = "Desired capacity for spot node group"
}

variable "min_capacity_spot" {
  type        = string
  description = "Minimum capacity for spot node group"
}

variable "max_capacity_spot" {
  type        = string
  description = "Maximum capacity for spot node group"
}

variable "addons" {
  type = list(object({
    name                    = string
    version                 = optional(string)
    service_account_role_arn = optional(string)
  }))
  description = "List of EKS add-ons with optional version and service account role ARN"
}
