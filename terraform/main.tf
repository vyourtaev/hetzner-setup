# main.tf

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "tf-state.zerogravity.click"
    key            = "infra/iam-users.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

# Iterate over users
module "iam_users" {
  source = "./modules/iam_user"
  for_each = { for user in var.iam_users : user.name => user }

  user_name     = each.value.name
  env           = each.value.env
  system        = each.value.system
  ext_policy    = each.value.ext_policy
}