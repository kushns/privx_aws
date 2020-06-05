data "aws_ami" "centos7" {
  owners = [
  "679593333241"]
  most_recent = true

  filter {
    name = "name"
    values = [
    "CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name = "architecture"
    values = [
    "x86_64"]
  }

  filter {
    name = "root-device-type"
    values = [
    "ebs"]
  }
}

resource "random_password" "database_password" {
  length           = 20
  special          = true
  override_special = "!@#%-_=+"
}

resource "random_password" "superuser_password" {
  length           = 20
  special          = true
  override_special = "!@#%-_=+"
}

module "pgsql_database" {
  source            = "./modules/aws-rds-postgresql"
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  instance_type     = var.instance_typedb
  database_name     = var.database_name
  database_username = var.database_username
  database_password = "${var.database_password == "" ? random_password.database_password.result : var.database_password}"
  security_group    = [aws_security_group.privx-db.id]
}


module "redis_cache" {
  source             = "./modules/aws-elasti-cache-redis"
  node_type          = var.node_type
  security_group_ids = [aws_security_group.privx-redis.id]
}

resource "aws_instance" "privx" {
  ami           = data.aws_ami.centos7.id
  instance_type = var.instance_typeprivx
  tags = {
    Name      = "PrivX-terraform"
    Terraform = "True"
  }
  vpc_security_group_ids = [aws_security_group.privx.id]
  subnet_id              = aws_default_subnet.default.id
  root_block_device {
    delete_on_termination = true
  }
  associate_public_ip_address = true
  depends_on                  = [module.pgsql_database, module.redis_cache]
  key_name                    = var.key_name
  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y -q",
      "sudo rpm --import https://product-repository.ssh.com/info.fi-ssh.com-pubkey.asc",
      "sudo curl https://product-repository.ssh.com/ssh-products.repo -o /etc/yum.repos.d/ssh-products.repo",
      "sudo yum install PrivX -y -q",
      "cat <<EOF > config.sh",
      "export PRIVX_DNS_NAMES=\"${aws_instance.privx.private_dns} ${aws_instance.privx.public_dns}\"",
      "export PRIVX_IP_ADDRESSES=\"${aws_instance.privx.private_ip} ${aws_instance.privx.public_ip}\"",
      "export PRIVX_SUPERUSER=\"${var.privx_superuser}\"",
      "export PRIVX_SUPERUSER_PASSWORD=\"${var.superuser_password == "" ? random_password.superuser_password.result : var.superuser_password}\"",
      "export PRIVX_SUPERUSER_EMAIL=\"${var.privx_superuser}@${var.email_domain}\"",
      "export PRIVX_USE_EXTERNAL_DATABASE=1",
      "export PRIVX_DATABASE_NAME=\"${var.database_name}\"",
      "export PRIVX_DATABASE_USERNAME=\"${var.database_username}\"",
      "export PRIVX_DATABASE_PASSWORD=\"${var.database_password == "" ? random_password.database_password.result : var.database_password}\"",
      "export PRIVX_POSTGRES_ADDRESS=\"${module.pgsql_database.database_address}\"",
      "export PRIVX_POSTGRES_PORT=5432",
      "export DB_EXTERNAL_CREATE_PSQL_USER=false",
      "export DB_EXTERNAL_CREATE_PSQL_DATABASE=false",
      "export PRIVX_DATABASE_SSLMODE=require",
      "export PRIVX_REDIS_ADDRESS=\"${module.redis_cache.redis_address}\"",
      "export PRIVX_REDIS_PORT=6379",
      "export PRIVX_REDIS_PASSWORD_REQUIRED=0",
      "export PRIVX_KEYVAULT_PKCS11_ENABLE=0",
      "export PRIVX_NTP_SERVER=pool.ntp.org",
      "/opt/privx/scripts/postinstall.sh",
      "EOF",
      "sudo bash config.sh"
    ]
    connection {
      host        = self.public_dns
      user        = var.os_username
      private_key = file(var.private_key)
    }
  }
}

resource "aws_instance" "privx-carrier" {
  ami           = data.aws_ami.centos7.id
  instance_type = var.instance_typeprivxcarrier
  tags = {
    Name      = "PrivXcarrier-terraform"
    Terraform = "True"
  }
  vpc_security_group_ids = [aws_security_group.privx-carrier.id]
  subnet_id              = aws_default_subnet.default.id
  root_block_device {
    delete_on_termination = true
  }
  associate_public_ip_address = true
  key_name                    = var.key_name
  provisioner "remote-exec" {
    inline = [
      "sudo rpm --import https://product-repository.ssh.com/info.fi-ssh.com-pubkey.asc",
      "sudo curl https://product-repository.ssh.com/ssh-products.repo -o /etc/yum.repos.d/ssh-products.repo",
      "sudo yum install PrivX-Carrier -y -q"
    ]
    connection {
      host        = self.public_dns
      user        = var.os_username
      private_key = file(var.private_key)
    }
  }
}

resource "aws_instance" "privx-webproxy" {
  ami           = data.aws_ami.centos7.id
  instance_type = var.instance_typeprivxwebproxy
  tags = {
    Name      = "PrivXwebproxy-terraform"
    Terraform = "True"
  }
  vpc_security_group_ids = [aws_security_group.privx-webproxy.id]
  subnet_id              = aws_default_subnet.default.id
  root_block_device {
    delete_on_termination = true
  }
  associate_public_ip_address = true
  key_name                    = var.key_name
  depends_on                  = [aws_instance.privx-carrier]
  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y -q",
      "sudo rpm --import https://product-repository.ssh.com/info.fi-ssh.com-pubkey.asc",
      "sudo curl https://product-repository.ssh.com/ssh-products.repo -o /etc/yum.repos.d/ssh-products.repo",
      "sudo yum install PrivX-Web-Proxy -y -q",
      "sudo sed -i '/fe80::/a acl localnet src ${aws_instance.privx-carrier.private_ip}/32' /opt/privx/etc/squid.conf",
    ]
    connection {
      host        = self.public_dns
      user        = var.os_username
      private_key = file(var.private_key)
    }
  }
}

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
  value = "${var.database_password == "" ? random_password.database_password.result : "static"}"
}

output "superuser_password" {
  value = "${var.superuser_password == "" ? random_password.superuser_password.result : "static"}"
}