################################################################################
# Auto Scaling Group
################################################################################

resource "ncloud_auto_scaling_group" "this" {
  launch_configuration_no = var.launch_configuration_no

  name                    = var.asg_name
  subnet_no               = var.subnet_no
  server_name_prefix      = var.server_name_prefix
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  ignore_capacity_changes = var.ignore_capacity_changes

  default_cooldown          = var.default_cooldown
  health_check_grace_period = var.health_check_grace_period
  health_check_type_code    = var.health_check_type_code

  access_control_group_no_list = var.access_control_group_no_list
  target_group_list            = var.target_group_list

  # wait_for_capacity_timeout = var.wait_for_capacity_timeout
}


################################################################################
# Auto Scaling Policy
################################################################################

locals {
  auto_scaling_policies = {
    for x in var.var.auto_scaling_policies :
    x.name => x
  }
}

resource "ncloud_auto_scaling_policy" "this" {
  for_each = local.auto_scaling_policies

  auto_scaling_group_no = ncloud_auto_scaling_group.this.id

  name                 = each.value.name
  adjustment_type_code = each.value.adjustment_type_code
  scaling_adjustment   = each.value.scaling_adjustment
  min_adjustment_step  = each.value.min_adjustment_step
  cooldown             = each.value.cooldown
}


################################################################################
# Auto Scaling Schedule
################################################################################

locals {
  auto_scaling_schedules = {
    for x in var.auto_scaling_schedules :
    x.name => x
  }
}

resource "ncloud_auto_scaling_schedule" "this" {
  for_each = local.auto_scaling_schedules

  auto_scaling_group_no = ncloud_auto_scaling_group.this.id

  name             = each.value.name
  min_size         = each.value.min_size
  max_size         = each.value.max_size
  desired_capacity = each.value.desired_capacity
  time_zone        = each.value.time_zone
  start_time       = each.value.start_time
  recurrence       = each.value.recurrence
  end_time         = each.value.end_time
}
