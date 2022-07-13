
#buscando um rescurso ami da amazon 
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  #ira fazer o filtro de tudo oque estiver com o nome amazon
  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }

  #ira fazer o filtro de tudo oque estiver na arquitetura x86-64
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



#buscando a bubnet criada no diretorio vpc/
data "aws_subnet" "app-public-subnet" {
  cidr_block = "10.0.101.0/24"
}

data "aws_vpc" "vpc" {
    filter {
      name = "tag:Name"
      values = [ var.vpc_name ]
    }
}

data "template_file" "ec2-mongodb" {
  template = file("${path.module}/files/mongodb.sh")
  vars = {
    version = var.mongodb_version
  }
}

data "template_file" "ec2-app" {
  template = file("${path.module}/files/ec2.sh")
  vars = {
    image = lookup (var.ec2-app, "image")
    port = lookup (var.ec2-app, "port")
    version = lookup (var.ec2-app, "version")
    mongodb_server = aws_instance.app-mongodb-dennis.private_ip
  }
}