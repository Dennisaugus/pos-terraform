module "modulo-pos-dennis" {
  source = "terraform-aws-modules/vpc/aws"
  name = var.vpc_name
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = var.cidr_public_subnet

  enable_vpn_gateway = false
  enable_nat_gateway = false
  enable_dns_hostnames = true

tags = var.labels
}