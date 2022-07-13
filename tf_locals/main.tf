variable "resource_tags" {
  type = map(string)
  default = {
    cc = "financeiro"
    time = "turma08"
  }
}

locals {
  required_tags = {
    "project" = "impacta"
    "env" = "prod"
  }

 #juntando o local com o variable
 tags = merge(var.resource_tags, local.required_tags)
}

output "tags" {
  value = local.tags

}