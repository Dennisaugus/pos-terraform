variable "project" {
  type = string
  default = "dennis-pos"
}


variable "cidr_block" {
  type = string
}

variable "instance_type_app" {
  type = map
  default = {
    dev = "t2.micro"
    qa = "t2.medium"
    prod = "t3.medium"
  }
}

variable "instance_type_momgodb" {
  type = string
  default = "t2.small"
}

variable "vpc_name" {
  type = string
}

variable "create_zone_dns" {
  type = bool
  default = false
}

variable "instance_count" {
  type = map
  default = {
    dev = "2"
    qa = "4"
    prod = "6"
  }
}

variable "mongodb_version" {
  type = string
  default = "5.0.2"
}

variable "ec2-app" {
  type = map  
  default = {
    version = "1.1.0"
    port = "8000"
    image = "skacko-api"
  }
}

variable "env" {
  type = string
  default = "dev"
}