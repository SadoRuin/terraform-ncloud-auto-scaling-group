################################################################################
# Server Image
################################################################################

data "ncloud_server_image" "server_image" {
  count = var.server_image_name != null ? 1 : 0

  filter {
    name   = "product_name"
    values = [var.server_image_name]
  }
}

data "ncloud_member_server_image" "member_server_image" {
  count = var.member_server_image_name != null ? 1 : 0

  filter {
    name   = "name"
    values = [var.member_server_image_name]
  }
}


################################################################################
# Server Product
################################################################################


locals {
  product_type = {
    "High CPU"      = "HICPU"
    "Standard"      = "STAND"
    "High Memory"   = "HIMEM"
    "CPU Intensive" = "CPU"
    "GPU"           = "GPU"
    "BareMetal"     = "BM"
  }
}

data "ncloud_server_product" "server_product" {
  server_image_product_code = (
    var.server_image_name != null
    ? data.ncloud_server_image.server_image[0].id
    : data.ncloud_member_server_image.member_server_image[0].original_server_image_product_code
  )

  filter {
    name   = "generation_code"
    values = [upper(var.product_generation)]
  }
  filter {
    name   = "product_type"
    values = [local.product_type[var.product_type]]
  }
  filter {
    name   = "product_name"
    values = [var.product_name]
  }
}


################################################################################
# Launch Configuration
################################################################################

resource "ncloud_launch_configuration" "this" {
  name = var.lc_name

  server_image_product_code = (
    var.server_image_name != null
    ? data.ncloud_server_image.server_image[0].id
    : null
  )

  member_server_image_no = (
    var.member_server_image_name != null
    ? data.ncloud_member_server_image.member_server_image[0].id
    : null
  )

  server_product_code = data.ncloud_server_product.server_product.id
  is_encrypted_volume = var.is_encrypted_volume
  init_script_no      = var.init_script_no
  login_key_name      = var.login_key_name
}


################################################################################
# Auto Scaling Group
################################################################################

resource "ncloud_auto_scaling_group" "this" {
  launch_configuration_no = ncloud_launch_configuration.this.id

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
