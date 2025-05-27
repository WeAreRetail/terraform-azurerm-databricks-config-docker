#########################
# ADMIN USERS
#########################
data "databricks_group" "admins" {
  display_name = "admins"
}

data "azuread_group" "admin" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_admin
  security_enabled = true
}

data "azuread_users" "admin" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = data.azuread_group.admin[0].members
  ignore_missing = true
}

locals {
  admin_map = var.unity_permissions_migration ? { for v in data.azuread_users.admin[0].users : v.user_principal_name => v } : {}
  admin_set = var.unity_permissions_migration ? toset(data.azuread_users.admin[0].user_principal_names) : []
}

resource "databricks_group_member" "i-am-admin" {
  for_each = var.unity_permissions_migration ? {
    for k, r in databricks_user.all_users : k => r if contains(local.admin_set, k)
  } : {}
  group_id  = data.databricks_group.admins.id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

##########################
# DEVELOPERS USERS
##########################
resource "databricks_group" "analysts" {
  count        = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name = "analysts"
}

data "azuread_group" "user" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_user
  security_enabled = true
}

data "azuread_users" "users" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = data.azuread_group.user[0].members
  ignore_missing = true
}

locals {
  user_map = var.unity_permissions_migration ? { for v in data.azuread_users.users[0].users : v.user_principal_name => v } : {}
  user_set = var.unity_permissions_migration ? toset(data.azuread_users.users[0].user_principal_names) : []
}

resource "databricks_group_member" "i-am-analyst" {
  for_each = var.unity_permissions_migration ? {
    for k, r in databricks_user.all_users : k => r if contains(local.user_set, k)
  } : {}

  group_id  = databricks_group.analysts[0].id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

moved {
  from = databricks_group.analysts
  to   = databricks_group.analysts[0]
}

##################################
# READ USERS
##################################

resource "databricks_group" "readonly" {
  count        = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name = "readonly"
}

moved {
  from = databricks_group.readonly
  to   = databricks_group.readonly[0]
}

data "azuread_group" "readonly" {
  count            = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  display_name     = var.group_read
  security_enabled = true
}

data "azuread_users" "readonly" {
  count          = var.unity_permissions_migration ? 1 : 0 # Only if migration is enabled.
  object_ids     = toset(data.azuread_group.readonly[0].members)
  ignore_missing = true
}

locals {
  readonly_map = var.unity_permissions_migration ? { for k, v in data.azuread_users.readonly[0].users : v.user_principal_name => v } : {}
  readonly_set = var.unity_permissions_migration ? toset(data.azuread_users.readonly[0].user_principal_names) : []
}

resource "databricks_group_member" "i-am-readonly" {
  for_each = var.unity_permissions_migration ? {
    for k, r in databricks_user.all_users : k => r if contains(local.readonly_set, k)
  } : {}
  group_id  = databricks_group.readonly[0].id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

##################################
# ALL USERS CREATION
##################################
resource "databricks_user" "all_users" {
  for_each              = var.unity_permissions_migration ? merge(local.readonly_map, local.user_map, local.admin_map) : {}
  provider              = databricks
  user_name             = each.value.user_principal_name
  display_name          = each.value.display_name
  external_id           = each.value.object_id
  workspace_access      = true
  force                 = true
  databricks_sql_access = false
}
