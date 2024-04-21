provider "aws" {
    region = "eu-west-2" # replace with your region
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            },
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_full_access" {
    role       = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_lambda_function" "binance_data_loader" {
    filename      = "lambda_function.zip" # replace with your zip file name
    function_name = "binance_data_loader"
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda_function.lambda_handler"
    runtime       = "python3.8"
}

resource "aws_s3_bucket" "bucket" {
    bucket = "binance_data" # replace with your bucket name
    acl    = "private"
}

resource "aws_lambda_function" "binance_data_loader" {
    # ...

    environment {
        variables = {
            BINANCE_API_URL = "https://api.binance.com/api/v3/ticker/price"
        }
    }
}