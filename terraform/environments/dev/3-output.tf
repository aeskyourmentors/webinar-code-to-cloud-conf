output "Execute_On_Your_Bastion_Host" {
  value = format("aws eks update-kubeconfig --region %s --name %s", var.aws_region, var.cluster_name)

}
