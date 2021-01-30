output "privx_publicdns" {
  value = aws_instance.privx.public_dns
}

output "privxwebprxy_publicdns" {
  value = aws_instance.privx-webproxy.public_dns
}

output "privxcarrier_publicdns" {
  value = aws_instance.privx-carrier.public_dns
}

output "privxwebproxy_privateip" {
  value = aws_instance.privx-webproxy.private_ip
}

output "database_password" {
  value = var.database_password == "random" ? random_password.database_password.result : "static"
}

output "superuser_password" {
  value = var.superuser_password == "random" ? random_password.superuser_password.result : "static"
}
