variable "env" {
  type = string
}

variable "size" {
  type = map    
  default = {
    "dev" = "small"
    "qa" = "Large"
    "prod" = "xlarge"
  }
}

output "ambiente" {
  value = lookup (var.size, var.env)
}