resource "aws_s3_bucket" "example" {
  bucket = var.bucketName
}

resource "aws_s3_bucket_website_configuration" "example-config" {
  bucket = aws_s3_bucket.example.bucket
  index_document = {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "example-policy" {
  bucket = aws_s3_bucket.example.id
  policy = templatefile("s3-policy.json", { bucket = var.bucketName })
}
