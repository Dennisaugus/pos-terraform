
#saida na tela do ip-publico da instancia app e o ip-privado da instancia do mongodb
output "aws_public_ip" {
  value = aws_instance.app-ec2-dennis[*].public_ip
}

output "aws_private_ip" {
  value = aws_instance.app-mongodb-dennis.private_ip
}

output "ec2_app_template" {
  value = data.template_file.ec2-app.rendered
}

output "ec2_mongodb_template" {
  value = data.template_file.ec2-mongodb.rendered
}