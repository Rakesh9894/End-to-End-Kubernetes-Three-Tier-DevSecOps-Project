vpc-name      = "Jenkins-vpc"
igw-name      = "Jenkins-igw"
subnet-name   = "Jenkins-subnet"
rt-name       = "Jenkins-route-table"
sg-name       = "Jenkins-sg"
instance-name = "Jenkins-server"
key-name      = "rakesh"
iam-role      = "Jenkins-iam-role"

# EKS Addons
addons = [
  {
    name    = "coredns"
    version = "v1.11.4-eksbuild.14"
  },
  {
    name    = "kube-proxy"
    version = "v1.29.0-eksbuild.1"
  }
]
