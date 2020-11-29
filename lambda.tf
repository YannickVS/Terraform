#LAMBDA

#Python code upload
data "archive_file" "python-upload" {
    type = "zip"

    source_file = "functie/lambda_function-1.py"
    output_path = "functie/lambda_function-1.zip"
}

#IAM Rol
resource "aws_iam_role" "iam-lambda" {
    name = "lab6-iam-lambda"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Lambda functie
resource "aws_lambda_function" "lambdafunc" {
    filename      = "functie/lambda_function-1.zip"
    function_name = "lab6-lambdafunc"
    role          = aws_iam_role.iam-lambda.arn
    handler       = "lambda_function-1.lambda_handler"
    runtime       = "python3.8"
}

#HTTP API Gateway
resource "aws_apigatewayv2_api" "http-api-GW" {
    name          = "http-api-GW"
    protocol_type = "HTTP"
    target = aws_lambda_function.lambdafunc.arn
}

#aws_lambda_permission
resource "aws_lambda_permission" "permission-GW" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambdafunc.arn
	principal     = "apigateway.amazonaws.com"

	source_arn = "${aws_apigatewayv2_api.http-api-GW.execution_arn}/*/*"
}