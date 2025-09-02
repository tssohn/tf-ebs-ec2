variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "profile" {
  type        = string
  default     = "sctp"
  description = "AWS CLI profile"
}

variable "name_prefix" {
  type        = string
  default     = "cet-11-tssohn"
  description = "Resource name prefix"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-018c8140694238ceb"
  description = "Target VPC"
}

variable "subnet_id" {
  type        = string
  default     = "subnet-018cf580efa2087a2"
  description = "Subnet for the EC2 instance"
}
