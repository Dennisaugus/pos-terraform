module "dennis-pos-module" {
  source = "./modules/dennis-pos-app/"
  cidr_blocks = var.cidr_blocks
  vpc_name = "dennis-pos-vpc"
  project = "dennis-pos-project"  
  env = var.env
  create_zone_dns = var.create_zone_dns
}

output "ip_app" {
  value = module.dennis-pos-module.aws_public_ip
}


variable "cidr_blocks" {
  type =string
  default = "10.0.100.0/24"
}
variable "env" {
  type = string
}

variable "create_zone_dns" {
  type = bool
  default = "true"
}