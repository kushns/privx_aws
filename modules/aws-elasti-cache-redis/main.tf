resource "aws_elasticache_cluster" "default" {
  cluster_id           = "privx-redis"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  security_group_ids   = var.security_group_ids

  tags = {
    Name      = "redis"
    Terraform = "True"
  }
}
