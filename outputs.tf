output "launch_configuration" {
  description = "Launch Configuration 출력"
  value       = ncloud_launch_configuration.this
}

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
