# Application Identity infos

data "azurerm_key_vault_secret" "spn_id" {
  name         = "spn-application-id"
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "spn_secret" {
  name         = "spn-application-secret"
  key_vault_id = var.key_vault_id
}
