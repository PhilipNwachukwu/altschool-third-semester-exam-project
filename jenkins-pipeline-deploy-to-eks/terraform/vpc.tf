data "aws_availability_zones" "azs" {
  state = "available"
}

module "altschoolapp_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "altschoolapp_vpc"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  enable_vpn_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform                                        = "true"
    Environment                                      = "dev"
    "kubernetes.io/cluster/altschoolapp-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/altschoolapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                         = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/altschoolapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                = 1
  }
}
