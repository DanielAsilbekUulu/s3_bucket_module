resource "aws_s3_bucket" "some_bucket" {    #This resource block creates a bucket. 
  bucket = var.bucket_name
  #count = var.number_of_buckets
  tags = {   # it will attach this tag to any bucket that is created by this module 
    "managed-by" = "terraform"
  }
}


resource "aws_s3_bucket_acl" "some_bucket_act" {
  bucket = aws_s3_bucket.some_bucket.id
  acl = "private"
}
 

resource "aws_s3_bucket_versioning" "some_bucket_versioning" {
  bucket = aws_s3_bucket.some_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "some_bucket_config" {
  bucket = aws_s3_bucket.some_bucket.id
  rule {
    id = "mode-to-ia-or-glacier"
    transition {
      days = 30   #if the file is not touched for 30 days then it will move to standard
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 60 # if the file is not touched for 60 days then it will move to glacier # the less you touch, the cheaper it gets 
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}