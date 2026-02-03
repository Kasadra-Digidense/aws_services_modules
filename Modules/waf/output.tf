# In the WAF module's outputs.tf
output "waf_acl_id" {
  value = aws_wafv2_web_acl.waf1_name.arn
}
