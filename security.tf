#Security

#SSH Key pair
resource "aws_key_pair" "ssh-key" {
	key_name="sshkey"
	public_key= "zelf in te voeren"
}




#Create VPC aws_security_group
resource "aws_security_group" "LABO-6-sec-group" {
  vpc_id      = aws_vpc.VPC_LABO6.id
  name        = "labo6_webserver"
  description = "Allow TCP inbound traffic"

  #Allow http port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow SSL port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SecGroup-lab6"
  }


}