

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}


#BUCKET


#Create private bucket
resource "aws_s3_bucket" "y" {
  bucket = "yannickvs"
  acl    = "private"

  tags = {
    Name        = "yannickvs"
  }
}

#Uploading a file to a bucket
resource "aws_s3_bucket_object" "foto" {
  bucket = aws_s3_bucket.y.id
  key    = "image.png"
  source = "s3/image.png"
  acl    = "public-read"
}




#EC2 Creation


#Create EC2 instance 1 in subnet 1
resource "aws_instance" "web" {
  ami                    = "ami-0aef57767f5404a3c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.LABO-6-sec-group.id]
  key_name = aws_key_pair.ssh-key.key_name
  subnet_id              = aws_subnet.LABO6_sub1.id

  user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				apt install php php-mysql libapache2-mod-php php-cli -y
				rm /var/www/html/index.html
				mv /home/ubuntu/index.php /var/www/html/			
        sed -i "s!lambda!${aws_apigatewayv2_api.http-api-GW.api_endpoint}!g" /var/www/html/index.php
				EOF  


  tags = {
    Name = "labo6_webserver1"
  }
  provisioner "file" {
    source      = "web/index.php"
    destination = "/home/ubuntu/index.php"
    connection {
      user        = "ubuntu"
      private_key = file("zelf in te voeren private key")
      host        = self.public_dns

    }
  }
}

#Create EC2 instance 2 in subnet 1
resource "aws_instance" "web2" {
  ami                    = "ami-0aef57767f5404a3c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.LABO-6-sec-group.id]
  key_name = aws_key_pair.ssh-key.key_name
  subnet_id              = aws_subnet.LABO6_sub1.id

  user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				apt install php php-mysql libapache2-mod-php php-cli -y
				rm /var/www/html/index.html
				mv /home/ubuntu/index.php /var/www/html/		
        sed -i "s!lambda!${aws_apigatewayv2_api.http-api-GW.api_endpoint}!g" /var/www/html/index.php	
				EOF  

  tags = {
    Name = "labo6_webserver2"
  }
  provisioner "file" {
    source      = "web/index.php"
    destination = "/home/ubuntu/index.php"
    connection {
      user        = "ubuntu"
      private_key = file("zelf in te voeren private key")
      host        = self.public_dns

    }
  }
}



#Create EC2 instance 3 in subnet 2
resource "aws_instance" "web3" {
  ami                    = "ami-0aef57767f5404a3c"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.LABO-6-sec-group.id]
  key_name = aws_key_pair.ssh-key.key_name
  subnet_id              = aws_subnet.LABO6_sub2.id

  user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				apt install php php-mysql libapache2-mod-php php-cli -y
				rm /var/www/html/index.html
				mv /home/ubuntu/index.php /var/www/html/	
        sed -i "s!lambda!${aws_apigatewayv2_api.http-api-GW.api_endpoint}!g" /var/www/html/index.php
				EOF  

  tags = {
    Name = "labo6_webserver3"
  }
  provisioner "file" {
    source      = "web/index.php"
    destination = "/home/ubuntu/index.php"
    connection {
      user        = "ubuntu"
      private_key = file("zelf in te voeren private key")
      host        = self.public_dns

    }
  }
}