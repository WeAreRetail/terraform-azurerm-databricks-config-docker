# Retrieve the secrets from Azure Key Vault

data "azurerm_key_vault_secrets" "keyvault_secrets" {
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "spn_id" {
  count        = var.unity_permissions_migration ? 1 : 0
  name         = "spn-application-id"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "spn_secret" {
  count        = var.unity_permissions_migration ? 1 : 0
  name         = "spn-application-secret"
  key_vault_id = var.key_vault_id
}
