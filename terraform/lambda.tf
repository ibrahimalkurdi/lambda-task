data "aws_iam_policy_document" "csv_to_json_lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.csv_to_json_lambda_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda-function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "csv_to_json_lambda_role_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "${var.project_name}-lambda-function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda-function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      Name = var.project_name
    }
  }
}

resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "function_sqs_permissoin" {
  name   = "function-sqs-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "sqs:SendMessage"
        ],
        Effect : "Allow",
        Resource : "arn:aws:sqs:*:*:*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "function_sqs_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_sqs_permissoin.arn
}


resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.csv_to_json_lambda_role_lambda.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_permission" "allow_bucket1" {
  statement_id  = "AllowExecutionFromS3Bucket1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csv_to_json_lambda_role_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.csv-to-json-bucket.arn
}

resource "aws_lambda_function_event_invoke_config" "csv_to_json" {
  function_name = aws_lambda_function.csv_to_json_lambda_role_lambda.arn

  destination_config {
    on_failure {
      destination = aws_sqs_queue.terraform_csv_to_json_queue_deadletter.arn
    }

    on_success {
      destination = aws_sqs_queue.terraform_csv_to_json_queue.arn
    }
  }
}

