resource "databricks_directory" "delivery" {
  path = "/delivery"
}

resource "databricks_permissions" "delivery_usage" {
  directory_path = databricks_directory.delivery.path
  depends_on     = [databricks_directory.delivery]

  access_control {
    group_name       = databricks_group.analysts.display_name
    permission_level = "CAN_EDIT"
  }

  access_control {
    group_name       = databricks_group.readonly.display_name
    permission_level = "CAN_READ"
  }
}
