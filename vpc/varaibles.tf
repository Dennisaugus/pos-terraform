variable "vpc_name" {
  type = string
  
}

variable "cidr_public_subnet" {
  type = list(string)
   default = [ "10.0.101.0/24", "10.0.102.0/24" ]
}

variable "labels" {
  type  = map 
  default = {
    "env" = "prd"
    "projeto" = "vpc"
   }
}