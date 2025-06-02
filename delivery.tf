# Configure the delivery folder where the notebooks will be delivered

resource "databricks_directory" "delivery" {
  path = "/delivery"
}

locals {
  delivery_usage_permissions_migration = var.unity_permissions_migration ? {
    access_control_can_edit = {
      group_name       = databricks_group.analysts[0].display_name
      permission_level = "CAN_EDIT"
    }
    access_control_can_read = {
      group_name       = databricks_group.readonly[0].display_name
      permission_level = "CAN_READ"
    }
  } : {}

  delivery_usage_permissions_unity = var.unity_permissions ? {
    access_control_can_edit_unity = {
      group_name       = local.users_group_name
      permission_level = "CAN_EDIT"
    }
    access_control_can_read_unity = {
      group_name       = local.read_group_name
      permission_level = "CAN_READ"
    }
  } : {}

  delivery_usage_permissions_merged = merge(
    local.delivery_usage_permissions_migration,
    local.delivery_usage_permissions_unity
  )
}

resource "databricks_permissions" "delivery_usage" {
  directory_path = databricks_directory.delivery.path

  dynamic "access_control" {
    for_each = local.delivery_usage_permissions_merged
    content {
      group_name       = access_control.value["group_name"]
      permission_level = access_control.value["permission_level"]
    }
  }
}

moved {
  from = databricks_permissions.delivery_usage[0]
  to   = databricks_permissions.delivery_usage
}
