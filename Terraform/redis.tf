resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [module.network.private_subnet_id, module.network.private_subnet_id2]

  tags = {
    Name = "Redis Subnet Group"
  }
}

resource "aws_elasticache_cluster" "Terraform_elasticache" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  port                 = 6379
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}
