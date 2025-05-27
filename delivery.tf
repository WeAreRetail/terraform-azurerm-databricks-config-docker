# Configure the delivery folder where the notebooks will be delivered

resource "databricks_directory" "delivery" {
  path = "/delivery"
}

resource "databricks_permissions" "delivery_usage" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  directory_path = databricks_directory.delivery.path

  access_control {
    group_name       = databricks_group.analysts[0].display_name
    permission_level = "CAN_EDIT"
  }

  access_control {
    group_name       = databricks_group.readonly[0].display_name
    permission_level = "CAN_READ"
  }
}

resource "databricks_permissions" "delivery_usage_unity" {
  count          = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  directory_path = databricks_directory.delivery.path
  depends_on     = [databricks_directory.delivery]

  access_control {
    group_name       = local.users_group_name
    permission_level = "CAN_EDIT"
  }

  access_control {
    group_name       = local.read_group_name
    permission_level = "CAN_READ"
  }
}

moved {
  from = databricks_permissions.delivery_usage
  to   = databricks_permissions.delivery_usage[0]
}
