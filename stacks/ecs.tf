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
  frontend_repo_name = "frontend"
  backend_repo_name = "backend"
}

module "load_balancer_public" {
  source     = "../modules/load-balancer"
  alb_name = "three-tier-alb"
  frontend_tg = "frontend-tg-v0"
  backend_tg = "backend-tg-v0"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.security_group.alb_sg_id
  
}
module "load_balancer_private" {
  source     = "../modules/load-balancer"
  alb_name = "three-tier-alb-v1"
  frontend_tg = "frontend-tg-v1"
  backend_tg = "backend-tg-v1"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.security_group.alb_sg_id
  
}
module "load_balancer_third" {
  source     = "../modules/load-balancer"
  alb_name = "three-tier-alb-v2"
  frontend_tg = "frontend-tg-v2"
  backend_tg = "backend-tg-v2"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.security_group.alb_sg_id
  
}

module "ecs_public" {
  source                  = "../modules/ecs"
  cluster_name            = "three-tier-cluster"
  frontend_image          = module.ecr.frontend_repo_url
  backend_image           = module.ecr.backend_repo_url
  mongo_connection_string = "mongodb://admin:secret123@10.0.1.158:27017/taskmanager?authSource=admin"
  task_execution_role     = "ecsTaskExecutionRole-v0"
  frontend_family         = "frontend-task"
  frontend_cont           = "frontend"
  backend_family          = "backend-task"
  backend_cont            = "backend"
  mongodb_family          = "mongodb-task"
  mongodb_cont            = "mongodb"
  frontend_cpu            = "256"
  frontend_memory         = "512"
  frontend_port           = 3000
  backend_cpu             = "256"
  backend_memory          = "512"
  backend_port            = 3500
  mongo_image             = "mongo:6"
  mongo_cpu               = "256"
  mongo_memory            = "512"
  mongo_port              = 27017
  frontend_service        = "frontend-service"
  backend_service         = "backend-service"
  mongodb_service         = "mongodb-service"

  subnet_ids           = module.vpc.public_subnet_ids
  ecs_sg_id            = module.security_group.ecs_sg_id
  frontend_tg_arn      = module.load_balancer_public.frontend_target_group_arn
  backend_tg_arn       = module.load_balancer_public.backend_target_group_arn
}

module "ecs_private" {
  source                  = "../modules/ecs"
  cluster_name            = "three-tier-cluster-v1"
  frontend_image          = module.ecr.frontend_repo_url
  backend_image           = module.ecr.backend_repo_url
  mongo_connection_string = "mongodb://admin:secret123@10.0.1.32:27017/taskmanager?authSource=admin"
  task_execution_role     = "ecsTaskExecutionRole-v1"
  frontend_family         = "frontend-task-v1"
  frontend_cont           = "frontend-v1"
  backend_family          = "backend-task-v1"
  backend_cont            = "backend-v1"
  mongodb_family          = "mongodb-task-v1"
  mongodb_cont            = "mongodb-v1"
  frontend_cpu            = "256"
  frontend_memory         = "512"
  frontend_port           = 3000
  backend_cpu             = "256"
  backend_memory          = "512"
  backend_port            = 3500
  mongo_image             = "mongo:6"
  mongo_cpu               = "256"
  mongo_memory            = "512"
  mongo_port              = 27017
  frontend_service        = "frontend-service-v1"
  backend_service         = "backend-service-v1"
  mongodb_service         = "mongodb-service-v1"

  subnet_ids           = module.vpc.public_subnet_ids
  ecs_sg_id            = module.security_group.ecs_sg_id
  frontend_tg_arn      = module.load_balancer_private.frontend_target_group_arn
  backend_tg_arn       = module.load_balancer_private.backend_target_group_arn
}

module "ecs_third" {
  source                  = "../modules/ecs"
  cluster_name            = "three-tier-cluster-v2"
  frontend_image          = module.ecr.frontend_repo_url
  backend_image           = module.ecr.backend_repo_url
  mongo_connection_string = "mongodb://admin:secret123@10.0.1.57:27017/taskmanager?authSource=admin"
  task_execution_role     = "ecsTaskExecutionRole-v2"
  frontend_family         = "frontend-task-v2"
  frontend_cont           = "frontend-v2"
  backend_family          = "backend-task-v2"
  backend_cont            = "backend-v2"
  mongodb_family          = "mongodb-task-v2"
  mongodb_cont            = "mongodb-v2"
  frontend_cpu            = "256"
  frontend_memory         = "512"
  frontend_port           = 3000
  backend_cpu             = "256"
  backend_memory          = "512"
  backend_port            = 3500
  mongo_image             = "mongo:6"
  mongo_cpu               = "256"
  mongo_memory            = "512"
  mongo_port              = 27017
  frontend_service        = "frontend-service-v2"
  backend_service         = "backend-service-v2"
  mongodb_service         = "mongodb-service-v2"

  subnet_ids           = module.vpc.public_subnet_ids
  ecs_sg_id            = module.security_group.ecs_sg_id
  frontend_tg_arn      = module.load_balancer_third.frontend_target_group_arn
  backend_tg_arn       = module.load_balancer_third.backend_target_group_arn
}

module "load_balancer_test" {
  source     = "../modules/load-balancer"
  alb_name = "three-tier-alb-test"
  frontend_tg = "frontend-tg-test"
  backend_tg = "backend-tg-test"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.security_group.alb_sg_id
  
}

module "ecs_test" {
  source                  = "../modules/ecs"
  cluster_name            = "three-tier-cluster-test"
  frontend_image          = module.ecr.frontend_repo_url
  backend_image           = module.ecr.backend_repo_url
  mongo_connection_string = "mongodb://admin:secret123@10.0.1.193:27017/taskmanager?authSource=admin"
  task_execution_role     = "ecsTaskExecutionRole-test"
  frontend_family         = "frontend-task-test"
  frontend_cont           = "frontend-test"
  backend_family          = "backend-task-test"
  backend_cont            = "backend-test"
  mongodb_family          = "mongodb-task-test"
  mongodb_cont            = "mongodb-test"
  frontend_cpu            = "256"
  frontend_memory         = "512"
  frontend_port           = 3000
  backend_cpu             = "256"
  backend_memory          = "512"
  backend_port            = 3500
  mongo_image             = "mongo:6"
  mongo_cpu               = "256"
  mongo_memory            = "512"
  mongo_port              = 27017
  frontend_service        = "frontend-service-test"
  backend_service         = "backend-service-test"
  mongodb_service         = "mongodb-service-test"

  subnet_ids           = module.vpc.public_subnet_ids
  ecs_sg_id            = module.security_group.ecs_sg_id
  frontend_tg_arn      = module.load_balancer_test.frontend_target_group_arn
  backend_tg_arn       = module.load_balancer_test.backend_target_group_arn
}