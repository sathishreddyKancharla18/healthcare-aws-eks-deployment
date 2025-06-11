module "vpc" {
  source = "../vpc"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs            = var.azs
}

module "iam" {
  source = "../iam"
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = module.iam.eks_cluster_role_arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  }

  depends_on = [
    module.iam
  ]
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-nodegroup"
  node_role_arn   = module.iam.eks_nodegroup_role_arn
  subnet_ids      = module.vpc.private_subnet_ids

  scaling_config {
    desired_size = var.node_desired_capacity
    max_size     = var.node_max_capacity
    min_size     = var.node_min_capacity
  }

  instance_types = var.instance_types
  ami_type       = "AL2_x86_64"

  depends_on = [aws_eks_cluster.this]
}
