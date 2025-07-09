output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "frontend_service_name" {
  description = "Name of the ECS frontend service"
  value       = aws_ecs_service.frontend.name
}

output "backend_service_name" {
  description = "Name of the ECS backend service"
  value       = aws_ecs_service.backend.name
}

output "mongodb_service_name" {
  description = "Name of the ECS MongoDB service"
  value       = aws_ecs_service.mongodb.name
}
