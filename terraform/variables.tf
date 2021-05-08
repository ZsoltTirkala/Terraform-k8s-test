data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

variable "region" {
  default = "eu-west-2"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "003235076673",
  ]
}

variable "ecr_repository_name" {
  description = "ECR repository's name"
  type        = string
  default     = "application-test-ecr"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
     {
      rolearn  = "arn:aws:iam::003235076673:role/ec2-role"
      username = "ec2-role"
      groups   = ["system:masters"]
    }
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::003235076673:user/tirkala.zsolt@gmail.com"
      username = "zsolt-test-terra-k8s"
      groups   = ["system:masters"]
    },
  ]
}
