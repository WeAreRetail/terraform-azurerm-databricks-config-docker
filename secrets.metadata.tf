################################################
# METADATA
################################################

# Contains information about the project and its execution context.
resource "databricks_secret_scope" "metadata" {
  name = "metadata"
}

resource "databricks_secret_acl" "metadata" {
  count = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.

  principal  = databricks_group.analysts[0].display_name
  permission = "READ"
  scope      = databricks_secret_scope.metadata.name
}

moved {
  from = databricks_secret_acl.metadata
  to   = databricks_secret_acl.metadata[0]
}

resource "databricks_secret_acl" "metadata_unity" {
  count = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.

  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.metadata.name
}

# Databricks secret register

# The execution environment.
resource "databricks_secret" "environment" {
  key          = "ENVIRONMENT"
  string_value = upper(var.environment)
  scope        = databricks_secret_scope.metadata.name
}

# The project trigram.
resource "databricks_secret" "trigram" {
  key          = "TRIGRAM"
  string_value = upper(var.trigram)
  scope        = databricks_secret_scope.metadata.name
}
