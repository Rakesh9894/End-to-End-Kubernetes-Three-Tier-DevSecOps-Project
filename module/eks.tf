resource "aws_eks_cluster" "eks" {
  count    = var.is-eks-cluster-enabled == true ? 1 : 0
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-cluster-role[count.index].arn
  version  = var.cluster-version

  vpc_config {
    subnet_ids = [
      aws_subnet.private-subnet[0].id,
      aws_subnet.private-subnet[1].id,
      aws_subnet.private-subnet[2].id
    ]
    endpoint_private_access = var.endpoint-private-access
    endpoint_public_access  = var.endpoint-public-access
    security_group_ids      = [aws_security_group.eks-cluster-sg.id]
  }

  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster-name
    Env  = var.env
  }
}

# OIDC Provider
resource "aws_iam_openid_connect_provider" "eks-oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks-certificate.url
}

# Data source for add-on versions
data "aws_eks_addon_version" "addons" {
  for_each           = { for addon in var.addons : addon.name => addon }
  addon_name         = each.value.name
  kubernetes_version = var.cluster-version
  most_recent        = true
}

# EKS Add-ons
resource "aws_eks_addon" "eks-addons" {
  for_each                   = { for idx, addon in var.addons : idx => addon }
  cluster_name               = aws_eks_cluster.eks[0].name
  addon_name                 = each.value.name
  addon_version              = data.aws_eks_addon_version.addons[each.value.name].version
  service_account_role_arn   = try(each.value.service_account_role_arn, null)

  depends_on = [
    aws_eks_node_group.ondemand-node,
    aws_eks_node_group.spot-node
  ]
}

# On-Demand Node Group
resource "aws_eks_node_group" "ondemand-node" {
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster-name}-on-demand-nodes"
  node_role_arn   = aws_iam_role.eks-nodegroup-role[0].arn

  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size     = var.min_capacity_on_demand
    max_size     = var.max_capacity_on_demand
  }

  subnet_ids = [
    aws_subnet.private-subnet[0].id,
    aws_subnet.private-subnet[1].id,
    aws_subnet.private-subnet[2].id
  ]

  instance_types = var.ondemand_instance_types
  capacity_type  = "ON_DEMAND"

  labels = {
    type = "ondemand"
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    "Name" = "${var.cluster-name}-ondemand-nodes"
  }

  depends_on = [aws_eks_cluster.eks]
}

# Spot Node Group
resource "aws_eks_node_group" "spot-node" {
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = "${var.cluster-name}-spot-nodes"
  node_role_arn   = aws_iam_role.eks-nodegroup-role[0].arn

  scaling_config {
    desired_size = var.desired_capacity_spot
    min_size     = var.min_capacity_spot
    max_size     = var.max_capacity_spot
  }

  subnet_ids = [
    aws_subnet.private-subnet[0].id,
    aws_subnet.private-subnet[1].id,
    aws_subnet.private-subnet[2].id
  ]

  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"

  labels = {
    type      = "spot"
    lifecycle = "spot"
  }

  update_config {
    max_unavailable = 1
  }

  disk_size = 50

  tags = {
    "Name" = "${var.cluster-name}-spot-nodes"
  }

  depends_on = [aws_eks_cluster.eks]
}
