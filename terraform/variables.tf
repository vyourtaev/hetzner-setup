# variables.tf

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "iam_users" {
  type = list(object({
    name       = string
    env        = string
    system     = string
    ext_policy = optional(list(object({
      Effect   = string
      Action   = list(string)
      Resource = string
    })), [])
  }))
}