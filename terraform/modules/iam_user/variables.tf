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

variable "ext_policy" {
  type = list(object({
    Effect    = string
    Action    = list(string)
    Resource  = string
  }))
  default = []
}