################################################
# SECURITY
################################################

resource "databricks_secret_scope" "security" {
  name = "security"
}

resource "databricks_secret_acl" "security" {
  count      = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  principal  = databricks_group.analysts[0].display_name
  permission = "READ"
  scope      = databricks_secret_scope.security.name
}

moved {
  from = databricks_secret_acl.security
  to   = databricks_secret_acl.security[0]
}

resource "databricks_secret_acl" "security_unity" {
  count      = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.security.name
}

# Databricks secret register

resource "databricks_secret" "spn_secret" {
  key          = "spn-secret_${data.azurerm_key_vault_secret.spn_secret.version}"
  string_value = data.azurerm_key_vault_secret.spn_secret.value
  scope        = databricks_secret_scope.security.name

  lifecycle {
    create_before_destroy = true
  }
}

# Static version used for docker credentials
resource "databricks_secret" "spn_secret_docker" {
  key          = "acr-secret"
  string_value = data.azurerm_key_vault_secret.spn_secret.value
  scope        = databricks_secret_scope.security.name
}

resource "databricks_secret" "spn_id_key" {
  key          = "spn-id"
  string_value = data.azurerm_key_vault_secret.spn_id.value
  scope        = databricks_secret_scope.security.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "databricks_secret" "tenant_id" {
  key          = "tenant-id"
  string_value = var.tenant_id
  scope        = databricks_secret_scope.security.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "databricks_secret" "client_id" {
  key          = "client-id"
  string_value = length(local.databricks_identities) > 0 ? one(local.databricks_identities) : "no_dbmanagedidentity"
  scope        = databricks_secret_scope.security.name
}
