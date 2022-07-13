

#criando um por der chaves .pem     -> comando: $ ssh-keygen -C dennis-pos -f dennis-pos
resource "aws_key_pair" "app-ssh-key" {
  key_name = "dennis-pos"
  #conteudo gerado da chave publica
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfLg1O5nPt039zO0is5dj1dSbJD/Yl5tK388cCys0S/c5ausNnnr8l4FsH/MBEW5GHIQtOHfLFXKd+kPXDqd1RfqQh1x6aAmL4s2KgQAzM6n/x+dWnoGTLtUpqtEakczNImRPsZtbZviK03wwOiC2NLpLbFmXt6CoQ0zCfjTyP9y68T3lSCV8xvSJIqN1za5KnTwFjwD6oxse5spbNczkyBP7kRXlEgRZGONX2w+cNTrLg3GeJ8EDSsgJB+NjRMVwTXLlvEWfqNCbcb8OenSDZk7DJPoNBHETJxgtv1j+Czrv/0hVA6/Ir9G80vZcl2iOAkvrhUllBmhLdJWceqmoU5YbW6fdYGsx5CTGRqJD61lDt3E3kUA/HG24/RqJ6rWZYzWr+WXSt9K9CsOwOZ8Lk0Phz/UrePB6m+19VbHEtckpPRegSZFXMXf9Sly+2xpLoLk/nkWzHK15x+Dl0cIs1V7zVudOfHz6CWcXDzMr6i4zjtaL/HU6nDNNizd86Wf0= dennis-pos"

}

resource "aws_instance" "app-ec2-dennis" {
  #buscando o data criado da ami
  count = lookup (var.instance_count, var.env)
  ami           = data.aws_ami.amazon-linux.id
  instance_type = lookup(var.instance_type_app ,var.env)
  #atribuindo o data da subnet
  subnet_id = data.aws_subnet.app-public-subnet.id
  #associando um ip publico na instancia
  associate_public_ip_address = true

  tags = {
    "Name" = format("%s-app", local.name)
  }

  #atribuindo uma chave de acesso criada
  key_name = aws_key_pair.app-ssh-key.id
  #usado para executar comandos linux na hora da criação da instancia neste exemplo usa-se um aquivo que é o mais indicado
  user_data = data.template_file.ec2-app.rendered

}

#criando instancia do mongodb
resource "aws_instance" "app-mongodb-dennis" {
  #buscando o data criado da ami
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type_momgodb
  #atribuindo o data da subnet
  subnet_id = data.aws_subnet.app-public-subnet.id

  tags = {
    "Name" = format("%s-mongodb", local.name)
  }

  #atribuindo uma chave de acesso criada
  key_name = aws_key_pair.app-ssh-key.id
  #usado para executar comandos linux na hora da criação da instancia neste exemplo usa-se um aquivo que é o mais indicado
  user_data = data.template_file.ec2-mongodb.rendered
}

#criando um recurso de security group para liberação de acesso http e ssh
resource "aws_security_group" "allow-http-ssh" {
  name        = format("%s-aws-security-group", local.name)
  description = "allow http and ssh ports"
  vpc_id      = data.aws_vpc.vpc.id

  #regra de entrada
  ingress = [
    {
      description      = "allow-ssh"
      from_port        = "22"
      to_port          = "22"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self            = null
    },
    {
      description      = "allow-http"
      from_port        = "80"
      to_port          = "80"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self            = null
    }
  ]

  #regra de saida
  egress = [
    {
      description      = "allow-all"
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self            = null
    }
  ]
}

#security group do mongodb
resource "aws_security_group" "allow-mongodb" {
  name        = format("%s-allow-mongodb",local.name)
  description = "allow mongodb port"
  vpc_id      = data.aws_vpc.vpc.id

  #regra de entrada
  ingress = [
    {
      description      = "allow-mongodb"
      from_port        = "27017"
      to_port          = "27017"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self            = null
    }
  ]

  #regra de saida
  egress = [
    {
      description      = "allow-all"
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self            = null
    }
  ]
}


#associando o security group na máquina 
resource "aws_network_interface_sg_attachment" "app-sg" {
  count = lookup (var.instance_cout, var.env)
  security_group_id    = aws_security_group.allow-http-ssh.id
  network_interface_id = aws_instance.app-ec2-dennis[count.index].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "mongodb-sg" {
  security_group_id    = aws_security_group.allow-mongodb.id
  network_interface_id = aws_instance.app-mongodb-dennis.primary_network_interface_id
}

#criando uma zona DNS
resource "aws_route53_zone" "app-zone" {
  name = format("%s.com.br", var.project)
  count = var.env == "prod" ? 1 : var.create_zone_dns == false ? 0 : 1
  
  vpc {
    vpc_id = "vpc-0f3ff840c58791fff"
  }
}

resource "aws_route53_record" "mongodb" {
  count = var.env == "prod" ? 1 : var.create_zone_dns == false ? 0 : 1
  zone_id = aws_route53_zone.app-zone[count.index].id
  name    = format("mongodb.%s.com.br", var.project)
  type    = "A"
  ttl     = "300"
  records = [aws_instance.app-mongodb-dennis.private_ip]
}
