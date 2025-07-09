module "vpc" {
  source         = "../modules/vpc"
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
}

module "security_group" {
  source  = "../modules/security-group"
  vpc_id  = module.vpc.vpc_id
}

module "ecr" {
  source = "../modules/ecr"
}

module "load_balancer" {
  source     = "../modules/load-balancer"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.security_group.alb_sg_id
}

module "ecs" {
  source                  = "../modules/ecs"
  cluster_name            = "three-tier-cluster"
  frontend_image          = module.ecr.frontend_repo_url
  backend_image           = module.ecr.backend_repo_url
  mongo_connection_string = "mongodb://admin:secret123@<MONGODB_PRIVATE_IP>:27017/taskmanager?authSource=admin"

  subnet_ids     = module.vpc.public_subnet_ids
  ecs_sg_id      = module.security_group.ecs_sg_id
  frontend_tg_arn         = module.load_balancer.frontend_target_group_arn
  backend_tg_arn          = module.load_balancer.backend_target_group_arn
}