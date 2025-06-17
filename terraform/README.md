# main.tf

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = var.s3_bucket
    key            = var.s3_key
    region         = var.aws_region
    dynamodb_table = var.s3_lock_table
    encrypt        = true
  }
}

# Iterate over users
module "iam_users" {
  source = "./modules/iam_user"
  for_each = { for user in var.iam_users : user.name => user }

  user_name     = each.value.name
  secret_paths  = each.value.secret_paths
  env           = each.value.env
  system        = each.value.system
}


# variables.tf

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket for terraform state"
}

variable "s3_key" {
  type        = string
  description = "S3 key (path) for state file"
}

variable "s3_lock_table" {
  type        = string
  description = "DynamoDB table for state locking"
}

variable "iam_users" {
  type = list(object({
    name         = string
    env          = string
    system       = string
    secret_paths = list(string)
  }))
}


# terraform.tfvars

aws_region     = "us-east-1"
s3_bucket      = "my-terraform-state-bucket"
s3_key         = "infra/iam-users.tfstate"
s3_lock_table  = "terraform-locks"

iam_users = [
  {
    name         = "prod-cert-manager-user"
    env          = "prod"
    system       = "platform"
    secret_paths = ["/prod/platform/cert-manager/*"]
  },
  {
    name         = "prod-external-dns-user"
    env          = "prod"
    system       = "platform"
    secret_paths = ["/prod/platform/external-dns/*"]
  }
]


# modules/iam_user/main.tf

resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_user_policy" "this" {
  name = "${var.user_name}-secret-access"
  user = aws_iam_user.this.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      for path in var.secret_paths : {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:*:*:secret:${path}"
      }
    ]
  })
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_ssm_parameter" "access_key" {
  name  = "/${var.env}/${var.system}/${var.user_name}/access_key"
  type  = "SecureString"
  value = aws_iam_access_key.this.id
}

resource "aws_ssm_parameter" "secret_key" {
  name  = "/${var.env}/${var.system}/${var.user_name}/secret_key"
  type  = "SecureString"
  value = aws_iam_access_key.this.secret
}


# modules/iam_user/variables.tf

variable "user_name" {
  type = string
}

variable "env" {
  type = string
}

variable "system" {
  type = string
}

variable "secret_paths" {
  type = list(string)
}
