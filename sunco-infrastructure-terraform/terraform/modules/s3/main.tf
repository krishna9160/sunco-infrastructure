resource "aws_s3_bucket" "sunco" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "sunco" {
  bucket = aws_s3_bucket.sunco.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "sunco" {
  bucket = aws_s3_bucket.sunco.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sunco" {
  bucket = aws_s3_bucket.sunco.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_iam_policy" "sunco_s3" {
  name = "${var.bucket_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.sunco.arn}/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.sunco.arn
      }
    ]
  })
}



data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "eks" {
  url = var.eks_oidc_issuer_url
}

resource "aws_iam_role" "sunco_pod_s3" {
  name = "${var.project_name}-pod-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(var.eks_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"

            "${replace(var.eks_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:default:sunco-app"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sunco_pod_s3" {
  role       = aws_iam_role.sunco_pod_s3.name
  policy_arn = aws_iam_policy.sunco_s3.arn
}
