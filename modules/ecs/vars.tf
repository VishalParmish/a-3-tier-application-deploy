variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "frontend_image" {
  description = "ECR image URI for frontend"
  type        = string
}

variable "backend_image" {
  description = "ECR image URI for backend"
  type        = string
}

variable "mongo_connection_string" {
  description = "MongoDB connection string"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS services"
  type        = string
}

variable "frontend_tg_arn" {
  description = "Target group ARN for frontend"
  type        = string
}

variable "backend_tg_arn" {
  description = "Target group ARN for backend"
  type        = string
}

variable "task_execution_role" {}
variable "frontend_family" {}
variable "frontend_cont" {}
variable "backend_family" {}
variable "backend_cont" {}
variable "mongodb_family" {}
variable "mongodb_cont" {}
variable "frontend_cpu" {}
variable "frontend_memory" {}
variable "frontend_port" {
  type = number
}
variable "backend_cpu" {}
variable "backend_memory" {}
variable "backend_port" {
  type = number
}
variable "mongo_cpu" {}
variable "mongo_memory" {}
variable "mongo_port" {
  type = number
}
variable "mongo_image" {}
variable "frontend_service" {}
variable "backend_service" {}
variable "mongodb_service" {}