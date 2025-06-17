# modules/iam_user/main.tf
locals {
  secret_path = "${var.env}/${var.system}/${var.user_name}/*"
}


resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_user_policy" "this" {
  name = "${var.user_name}-secret-access"
  user = aws_iam_user.this.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement =  concat(
    [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:*:*:secret:${local.secret_path}"
      }
    ],
    var.ext_policy 
    )
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