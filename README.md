# Terraform
labo6_terraform

In security.tf kan je zelf uw public ssh key aanpassen:
#SSH Key pair
resource "aws_key_pair" "ssh-key" {
	key_name="sshkey"
	public_key= "zelf in te voeren public key"
}

In instance.tf moet je een private key connecteren die overeen komt met de public key 
provisioner "file" {
    source      = "web/index.php"
    destination = "/home/ubuntu/index.php"
    connection {
      user        = "ubuntu"
      private_key = file("Private key die matcht met public")
      host        = self.public_dns
}
