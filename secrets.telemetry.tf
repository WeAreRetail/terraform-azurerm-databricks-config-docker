#######################################################
# TELEMETRY
#######################################################

resource "databricks_secret_scope" "telemetry" {
  provider = databricks
  name     = "telemetry"
}

resource "databricks_secret_acl" "telemetry" {
  count      = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  principal  = databricks_group.analysts[0].display_name
  permission = "READ"
  scope      = databricks_secret_scope.telemetry.name
}

resource "databricks_secret_acl" "telemetry_unity" {
  count      = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.telemetry.name
}

resource "databricks_secret" "telemetry_connection_string" {
  key          = "connection-string"
  string_value = var.telemetry_connection_string
  scope        = databricks_secret_scope.telemetry.name
}
