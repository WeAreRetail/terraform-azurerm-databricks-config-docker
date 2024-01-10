################################################
# SECURITY
################################################

resource "databricks_secret_scope" "security" {
  name = "security"
}

resource "databricks_secret_acl" "security" {
  principal  = databricks_group.analysts.display_name
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
