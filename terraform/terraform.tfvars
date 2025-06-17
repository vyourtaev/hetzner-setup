aws_region     = "eu-central-1"

iam_users = [
  {
    name         = "cert-manager-user"
    env          = "hetzner"
    system       = "k8s"
    ext_policy   = [
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListHostedZonesByName"
        ]
        Resource = "*"
      }
    ]
  },
  {
    name         = "external-dns-user"
    env          = "hetzner"
    system       = "k8s"
    ext_policy = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  }
]