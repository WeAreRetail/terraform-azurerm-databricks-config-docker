################################################
# METADATA
################################################

# Contains information about the project and its execution context.
resource "databricks_secret_scope" "metadata" {
  name = "metadata"
}

resource "databricks_secret_acl" "metadata" {
  principal  = databricks_group.analysts.display_name
  permission = "READ"
  scope      = databricks_secret_scope.metadata.name
}

# Databricks secret register

# The execution environment.
resource "databricks_secret" "environment" {
  key          = "ENVIRONMENT"
  string_value = var.environment
  scope        = databricks_secret_scope.metadata.name

  lifecycle {
    create_before_destroy = true
  }
}

# The project trigram.
resource "databricks_secret" "trigram" {
  key          = "TRIGRAM"
  string_value = var.trigram
  scope        = databricks_secret_scope.metadata.name

  lifecycle {
    create_before_destroy = true
  }
}
