# terraform-eks1
In the main.tf file, add the provider code. This will ensure that you use the AWS provider.

Set up the first resource for the IAM role. This ensures that the role has access to EKS.
resource "aws_iam_role" "eks-iam-role" {
 name = "devopsthehardway-eks-iam-role"

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}

Once the role is created, attach these two policies to it:

AmazonEKSClusterPolicy
AmazonEC2ContainerRegistryReadOnly-EKS
The two policies allow you to properly access EC2 instances (where the worker nodes run) and EKS.

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

Once the role is created, attach these two policies to it:

AmazonEKSClusterPolicy
AmazonEC2ContainerRegistryReadOnly-EKS
The two policies allow you to properly access EC2 instances (where the worker nodes run) and EKS.

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

Once the policies are attached, create the EKS cluster.

resource "aws_eks_cluster" "devopsthehardway-eks" {
 name = "devopsthehardway-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

Set up an IAM role for the worker nodes. The process is similar to the IAM role creation for the EKS cluster except this time the policies that you attach will be for the EKS worker node policies. The policies include:

AmazonEKSWorkerNodePolicy
AmazonEKS_CNI_Policy
EC2InstanceProfileForImageBuilderECRContainerBuilds
AmazonEC2ContainerRegistryReadOnly
resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }

The last bit of code is to create the worker nodes. For testing purposes, use just one worker node in the scaling_config configuration. In production, follow best practices and use at least three worker nodes.

 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.devopsthehardway-eks.name
  node_group_name = "devopsthehardway-workernodes"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet_id_1, var.subnet_id_2]
  instance_types = ["t3.xlarge"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

  ]
 }
 
 Create a new file called variables.tf. When setting up the variables.tf file, you'll create the following two variables:

Subnet_id_1
Subnet_id_2

Within the variables.tf file, create the following variables:

 variable "subnet_id_1" {
  type = string
  default = "subnet-your_first_subnet_id"
 }
 
 variable "subnet_id_2" {
  type = string
  default = "subnet-your_second_subnet_id"
 }
 
 Create the EKS environment
To create the environment, ensure you're in the Terraform directory and module that you used to write the Terraform mode. Run the following commands:

terraform init. Initialize the environment and pull down the AWS provider.
terraform plan. Plan the environment and ensure no bugs are found.
terraform apply --auto-approve. Create the environment with the apply command, combined with auto-approve, to avoid prompts.
When you are ready to destroy all Terraform environments, ensure that you're in the Terraform module/directory that you used to create the EKS cluster. Then, run the terraform destroy command.
