variable "region" {
  type        = string
  description = "AWS regin"
}

variable "availability_zone" {
  type        = string
  description = "AWS availibility zone"
}

variable "instance_typeprivx" {
  default = "t2.medium"
  type    = string
  description = "EC2 instance type for Privx"
}

variable "instance_typeprivxcarrier" {
  default = "t2.medium"
  type    = string
  description = "EC2 instance type for Privx Web carrier"
}
variable "instance_typeprivxwebproxy" {
  default = "t2.medium"
  type    = string
  description = "EC2 instance type for Privx Web Proxy"
}

variable "key_name" {
  type        = string
  description = "AWS key pair name for SSH password less authentication"
}
variable "private_key" {
  type        = string
  description = "Private key path for key name specified above"
}

variable "privx_superuser" {
  default     = "admin"
  type        = string
  description = "Privx superuser name"
}
variable "superuser_password" {
  default     = ""
  type        = string
  description = "PrivX superuser password"
}
variable "email_domain" {
  default     = "example.com"
  type        = string
  description = "email domain to setup email id for privx superuser"
}

variable "allocated_storage" {
  default     = 20
  type        = number
  description = "Storage allocated to database instance"
}

variable "instance_typedb" {
  default     = "db.t2.medium"
  type        = string
  description = "Instance type for database instance"
}

variable "engine_version" {
  default     = "11.6"
  type        = string
  description = "Database engine version"
}

variable "database_name" {
  default     = "privx"
  type        = string
  description = "Name of database inside storage engine"
}

variable "database_username" {
  default     = "privx"
  type        = string
  description = "Name of user inside storage engine"
}

variable "database_password" {
  default     = ""
  type        = string
  description = "Database password inside storage engine"
}

variable "node_type" {
  default     = "cache.t2.small"
  type        = string
  description = "redis cache node type(memory capacity of node)"
}