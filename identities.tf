# Retrieving the Databricks managed identity

data "azurerm_resources" "databricks_identities" {
  type = "Microsoft.ManagedIdentity/userAssignedIdentities"
  name = "dbmanagedidentity"
  required_tags = {
    application   = "databricks"
    A_PROJECT     = upper(var.trigram)
    A_ENVIRONMENT = upper(var.environment)
  }
}

data "azurerm_user_assigned_identity" "databricks" {

  for_each = { for k in data.azurerm_resources.databricks_identities.resources : k.id => k }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

locals {
  databricks_identities = [for k, v in data.azurerm_user_assigned_identity.databricks : v.client_id]
}
