output "eks_cluster_endpoint" {
  value = aws_eks_cluster.samim-eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.samim-eks.certificate_authority
}
