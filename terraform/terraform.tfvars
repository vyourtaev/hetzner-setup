aws_region     = "eu-central-1"

iam_users = [
  {
    name         = "cert-manager-user"
    env          = "hetzner"
    system       = "k8s"
  },
  {
    name         = "external-dns-user"
    env          = "hetzner"
    system       = "k8s"
  }
]