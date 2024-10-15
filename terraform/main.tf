provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "lambda_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnet
resource "aws_subnet" "lambda_subnet" {
  vpc_id     = aws_vpc.lambda_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create Security Group
resource "aws_security_group" "lambda_sg" {
  vpc_id = aws_vpc.lambda_vpc.id
}

# Create IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create ECR Repository
resource "aws_ecr_repository" "todo_app_repo" {
  name = "todo-app-repo"
}

# AWS Lambda Function using the Docker Image
resource "aws_lambda_function" "todo_function" {
  function_name = "todo-app"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.todo_app_repo.repository_url}:latest"

  vpc_config {
    subnet_ids         = [aws_subnet.lambda_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "todo-api"
  protocol_type = "HTTP"
}

# API Gateway Integration with Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id            = aws_apigatewayv2_api.lambda_api.id
  integration_type  = "AWS_PROXY"
  integration_uri   = aws_lambda_function.todo_function.invoke_arn
}
