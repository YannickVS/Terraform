
provider "aws" {
	profile = "default"
	region  = "eu-west-1"
}

#Private Bucket w/ Tags
resource "aws_s3_bucket" "y" {
  	bucket = "yannickVS"
  	acl    = "private"

  	tags = {
    	Name        = "S3_bucket_yannick"
    	Environment = "Dev"
  	}
}

#Uploading a file to a bucket
resource "aws_s3_bucket_object" "foto" {
  	bucket = aws_s3_bucket.y.id
  	key    = "image.png"
  	source = "s3/image.png"
	acl = "public-read"
}

#Create VPC sec-group
resource "aws_security_group" "allow_tcp" {
	name = "labo6_webserver"
	description = "Allow TCP inbound traffic"
	
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create EC2 instance 
resource "aws_instance" "web" {
	ami           = "ami-014ce76919b528bff"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.allow_tcp.id]
	
    user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				EOF  
				
	tags = {
		Name = "labo6_webserver1"
	}
}
