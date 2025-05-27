##################################
# SPNs in groups
##################################

# User provided list of groups

data "azuread_group" "app_admin" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_admin
  security_enabled = true
}

data "azuread_group" "app_read" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_read
  security_enabled = true
}

data "azuread_group" "app_user" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_user
  security_enabled = true
}

data "azuread_service_principals" "admin" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = toset(data.azuread_group.app_admin[0].members)
  ignore_missing = true
}

data "azuread_service_principals" "read" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = toset(data.azuread_group.app_read[0].members)
  ignore_missing = true
}

data "azuread_service_principals" "user" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = toset(data.azuread_group.app_user[0].members)
  ignore_missing = true
}

# Unity standardized groups

data "azuread_group" "app_unity" {
  count            = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  display_name     = "GRP_UNI_AZURE_${upper(var.trigram)}_${upper(var.environment)}_APPLICATIONS"
  security_enabled = true
}

data "azuread_group" "delivery_unity" {
  count            = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  display_name     = "GRP_UNI_AZURE_${upper(var.trigram)}_${upper(var.environment)}_DELIVERY"
  security_enabled = true
}

data "azuread_service_principals" "admin_unity" {
  count          = var.unity_permissions ? 1 : 0 # Only if Unity permissions are enabled.
  object_ids     = toset(concat(data.azuread_group.app_unity[0].members, data.azuread_group.delivery_unity[0].members))
  ignore_missing = true
}



locals {
  app_admin_var_map   = var.unity_permissions_migration ? { for k, v in data.azuread_service_principals.admin[0].service_principals : v.application_id => v.display_name } : {}
  app_admin_unity_map = var.unity_permissions ? { for k, v in data.azuread_service_principals.admin_unity[0].service_principals : v.application_id => v.display_name } : {}

  app_read_map = var.add_apps_in_groups && var.unity_permissions_migration ? { for k, v in data.azuread_service_principals.read[0].service_principals : v.application_id => v.display_name } : {}
  app_user_map = var.add_apps_in_groups && var.unity_permissions_migration ? { for k, v in data.azuread_service_principals.user[0].service_principals : v.application_id => v.display_name } : {}

  app_admin_map = merge(
    local.app_admin_var_map,
    local.app_admin_unity_map
  )
}

resource "databricks_service_principal" "admins" {
  for_each       = local.app_admin_map
  application_id = each.key
  display_name   = each.value
  force          = true
}

resource "databricks_service_principal" "read" {
  for_each       = local.app_read_map
  application_id = each.key
  display_name   = each.value
  force          = true
}

resource "databricks_service_principal" "user" {
  for_each       = local.app_user_map
  application_id = each.key
  display_name   = each.value
  force          = true
}

resource "databricks_group_member" "app-are-admin" {
  for_each = {
    for k, r in databricks_service_principal.admins : k => r
  }
  group_id  = data.databricks_group.admins.id
  member_id = each.value.id
}

resource "databricks_group_member" "app-are-read" {
  for_each = {
    for k, r in databricks_service_principal.read : k => r
  }
  group_id  = databricks_group.readonly[0].id
  member_id = each.value.id
}

resource "databricks_group_member" "app-are-user" {
  for_each = {
    for k, r in databricks_service_principal.user : k => r
  }
  group_id  = databricks_group.analysts[0].id
  member_id = each.value.id
}
