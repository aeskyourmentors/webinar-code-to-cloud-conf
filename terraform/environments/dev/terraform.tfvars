aws_region             = "ap-south-1"
vpc_cidr_block         = "10.0.0.0/16"
subnet_public-1_cidr   = "10.0.32.0/20"
subnet_public-2_cidr   = "10.0.48.0/20"
subnet_private-1_cidr  = "10.0.0.0/20"
subnet_private-2_cidr  = "10.0.16.0/20"
cluster_name           = "mentors_Seminar"
created_by             = "yourmanetors"
EKS_Kubernetes_Version = "1.30"
private_nodegroup_1 = {
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]
  max_size       = 3
  min_size       = 1
  desired_size   = 1
}
jenkins_ec2_size = "t3.medium"