output "auto_scaling_group" {
  description = "Auto Scaling Group 출력"
  value       = ncloud_auto_scaling_group.this
}

output "auto_scaling_policy" {
  description = "Auto Scaling Policy 맵 출력"
  value       = ncloud_auto_scaling_policy.this
}

output "auto_scaling_schedule" {
  description = "Auto Scaling Schedule 맵 출력"
  value       = ncloud_auto_scaling_schedule.this
}
