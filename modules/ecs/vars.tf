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
