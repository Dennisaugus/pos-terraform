output "saida_subnet" {
  value = module.modulo-pos-dennis.public_subnet_arns
}

output "saida_subnet_especifica" {
  value = var.cidr_public_subnet[1]
}
output "saida_labels" {
  value = var.labels["env"]
}