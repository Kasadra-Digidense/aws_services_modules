output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}

output "app_sg_id" {
  value = module.app_sg.security_group_id
}
