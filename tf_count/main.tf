variable "usernames" {
  type = list
  default = ["dennis-test","augusto-test","jose-test","gusmao-test"]
}

#variable "countnodes" {
  #type = string
  #default = 10
#}

variable "size" {
  type = map
  default = {
    "dev" = 2
    "hom" = 4
    "prod" = 8
   }
}

variable "env" {
  type = string
}

variable "create_dns" {
  type = bool
  default = false
}
resource "aws_iam_user" "name" {
  #count = length(var.usernames)
  #count = var.countnodes
  #count = var.env == "poc" ? 1 : lookup(var.size, var.env)
  count  = var.create_dns == false ? 0 : 1
  name = 10
}