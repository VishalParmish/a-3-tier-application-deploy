variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "alb_name" {}
variable "frontend_tg" {}
variable "backend_tg" {}
