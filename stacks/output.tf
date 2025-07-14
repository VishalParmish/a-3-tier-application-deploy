output "public_alb_dns_name" {
  value = module.load_balancer_public.alb_dns_name
}

output "private_alb_dns_name" {
  value = module.load_balancer_private.alb_dns_name
}

output "third_alb_dns_name" {
  value = module.load_balancer_third.alb_dns_name
}


output "test_alb_dns_name" {
  value = module.load_balancer_test.alb_dns_name
}