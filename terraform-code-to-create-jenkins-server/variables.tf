variable "vpc_cidr_block" {
  type        = string
  description = "aws vpc cidr block"
}

variable "aws_region" {
  type        = string
  description = "aws resource region"
  default     = "eu-west-2"
}

variable "subnet_cidr_block" {
  type        = string
  description = "aws subnet cidr block"
}

# variable "avail_zone" {
#   type        = string
#   description = "aws availability zone"
# }

variable "env_prefix" {
  type        = string
  description = "prefix for environment"
}
variable "instance_type" {
  type        = string
  description = "value"
}
