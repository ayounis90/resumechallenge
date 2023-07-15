locals {
  resume_files = "../resume"
}

resource "aws_s3_bucket" "resume_challenge" {
  provider = aws.dev
  bucket   = var.bucketName
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset(local.resume_files, "**")
  provider = aws.shared
  bucket = aws_s3_bucket.resume_challenge.id
  key = each.key
  source = "${local.resume_files}/${each.value}"
}

resource "aws_s3_bucket_website_configuration" "resume_config" {
  bucket = aws_s3_bucket.resume_challenge.id
  index_document = {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "resume_challenge_policy" {
  bucket = aws_s3_bucket.resume_challenge.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketName })
}
