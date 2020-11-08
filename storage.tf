resource "aws_s3_bucket" "lamda-bucket" {
    bucket = "lamdabucket"
    acl    = "private"

    versioning {
        enabled = true
    }

    tags = {
        Name        = "Lamda Functions"
        Environment = "Dev"
    }
}

resource "aws_s3_bucket_object" "start-function" {
    bucket = aws_s3_bucket.lamda-bucket.id
    key    = "start.zip"
    source = "../aws_lamda_functions/bedrock_start.zip"

    etag = filemd5("../aws_lamda_functions/bedrock_start.zip")
}

resource "aws_s3_bucket_object" "stop-function" {
    bucket = aws_s3_bucket.lamda-bucket.id
    key    = "stop.zip"
    source = "../aws_lamda_functions/bedrock_stop.zip"

    etag = filemd5("../aws_lamda_functions/bedrock_stop.zip")
}