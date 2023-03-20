
resource "aws_sqs_queue" "terraform_csv_to_json_queue" {
  name                      = "${var.project_name}-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_csv_to_json_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Name = var.project_name
  }
}

resource "aws_sqs_queue" "terraform_csv_to_json_queue_deadletter" {
  name = "${var.project_name}-deadletter-queue"
}
