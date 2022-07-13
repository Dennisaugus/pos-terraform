variable "env" {
  type = string
}

data "template_file" "condicional" {
    template = file("arquivo.txt")
    vars = {
        value = var.env == "prod" ? "PROD" : "HOM"
    }
}

output "condicional" {
  value = data.template_file.condicional.*.rendered
}