#######################################################
# Well Known ACR
#######################################################

locals {
  acr_spn_id_key_name     = local.production ? "spn-databricks-prd-acr-auth-id" : "spn-databricks-npd-acr-auth-id"
  acr_spn_secret_key_name = local.production ? "spn-databricks-prd-acr-auth-secret" : "spn-databricks-npd-acr-auth-secret"

  # See keyvault.tf for the secrets retrieval
  acr_secrets_available = alltrue([
    length([for k in data.azurerm_key_vault_secrets.keyvault_secrets.names : k if k == local.acr_spn_id_key_name]) == 1,
    length([for k in data.azurerm_key_vault_secrets.keyvault_secrets.names : k if k == local.acr_spn_secret_key_name]) == 1,
  ])
}
# Get the ACR SPN ID and secret from the Key Vault

data "azurerm_key_vault_secret" "acr_spn_id" {
  count        = local.acr_secrets_available ? 1 : 0
  name         = local.acr_spn_id_key_name
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "acr_spn_secret" {
  count        = local.acr_secrets_available ? 1 : 0
  name         = local.acr_spn_secret_key_name
  key_vault_id = var.key_vault_id
}

# Set the ACR SPN ID and secret in Databricks secrets

resource "databricks_secret_scope" "registry" {
  name = "registry"
}

resource "databricks_secret_acl" "registry" {
  count      = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  principal  = databricks_group.analysts[0].display_name
  permission = "READ"
  scope      = databricks_secret_scope.registry.name
}

resource "databricks_secret_acl" "registry_unity" {
  count      = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  principal  = "users"
  permission = "READ"
  scope      = databricks_secret_scope.registry.name
}

resource "databricks_secret" "registry_password" {
  key          = "acr-password"
  string_value = local.acr_secrets_available ? one(data.azurerm_key_vault_secret.acr_spn_secret[*].value) : "not_set"
  scope        = databricks_secret_scope.registry.name

  lifecycle {
    postcondition {
      condition     = var.acr_uses_application_spn ? true : length(self.string_value) > 0
      error_message = "The ACR SPN secret is not set correctly."
    }
  }
}

resource "databricks_secret" "registry_id" {
  key          = "acr-username"
  string_value = local.acr_secrets_available ? one(data.azurerm_key_vault_secret.acr_spn_id[*].value) : "not_set"
  scope        = databricks_secret_scope.registry.name

  lifecycle {
    postcondition {
      condition     = var.acr_uses_application_spn ? true : length(self.string_value) > 0
      error_message = "The ACR SPN secret is not set correctly."
    }
  }
}
