
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.0"

  cluster_name                   = "altschoolapp-eks-cluster"
  cluster_version                = "1.24"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.altschoolapp_vpc.vpc_id
  subnet_ids = module.altschoolapp_vpc.private_subnets

  eks_managed_node_groups = {
    dev = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["t2.medium"]
    }

    tags = {
      Environment = "dev"
      Terraform   = "true"
      application = "altschoolapp"
    }
  }
}
