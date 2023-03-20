resource "aws_s3_bucket" "csv-to-json-bucket" {
  bucket = "${var.project_name}-only-for-test-2023"

  tags = {
    Name        = "${var.project_name}-only-for-test-2023"
  }
}

resource "aws_s3_bucket_acl" "acl-csv-to-json-bucket" {
  bucket = aws_s3_bucket.csv-to-json-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.csv-to-json-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.csv_to_json_lambda_role_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }


  depends_on = [
    aws_lambda_permission.allow_bucket1,
  ]
}
