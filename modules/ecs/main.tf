resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.task_execution_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = var.frontend_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.frontend_cpu
  memory                   = var.frontend_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.frontend_cont
      image     = var.frontend_image
      essential = true
      portMappings = [
        {
          containerPort = var.frontend_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "backend" {
  family                   = var.backend_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.backend_cont
      image     = var.backend_image
      essential = true
      portMappings = [
        {
          containerPort = var.backend_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MONGO_CONN_STR"
          value = var.mongo_connection_string
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "mongodb" {
  family                   = var.mongodb_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.mongo_cpu
  memory                   = var.mongo_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.mongodb_cont
      image     = var.mongo_image
      essential = true
      portMappings = [
        {
          containerPort = var.mongo_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MONGO_INITDB_ROOT_USERNAME"
          value = "admin"
        },
        {
          name  = "MONGO_INITDB_ROOT_PASSWORD"
          value = "secret123"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name            = var.frontend_service
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.frontend_tg_arn
    container_name   = var.frontend_cont
    container_port   = var.frontend_port
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}

resource "aws_ecs_service" "backend" {
  name            = var.backend_service
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.backend_tg_arn
    container_name   = var.backend_cont
    container_port   = var.backend_port
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}

resource "aws_ecs_service" "mongodb" {
  name            = var.mongodb_service
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.mongodb.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = true
  }
}
