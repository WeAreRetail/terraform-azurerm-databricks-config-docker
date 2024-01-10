#########################
# ADMIN USERS
#########################
data "databricks_group" "admins" {
  display_name = "admins"
}

data "azuread_group" "admin" {
  display_name     = var.group_admin
  security_enabled = true
}

data "azuread_users" "admin" {
  object_ids     = data.azuread_group.admin.members
  ignore_missing = true
}

locals {
  admin_map = { for v in data.azuread_users.admin.users : v.user_principal_name => v }
  admin_set = toset(data.azuread_users.admin.user_principal_names)
}

resource "databricks_group_member" "i-am-admin" {
  for_each = {
    for k, r in databricks_user.all_users : k => r if contains(local.admin_set, k)
  }
  group_id  = data.databricks_group.admins.id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

##########################
# DEVELOPPERS USERS
##########################
resource "databricks_group" "analysts" {
  display_name = "analysts"
}

data "azuread_group" "user" {
  display_name     = var.group_user
  security_enabled = true
}

data "azuread_users" "users" {
  object_ids     = data.azuread_group.user.members
  ignore_missing = true
}

locals {
  user_map = { for v in data.azuread_users.users.users : v.user_principal_name => v }
  user_set = toset(data.azuread_users.users.user_principal_names)
}

resource "databricks_group_member" "i-am-analyst" {
  for_each = {
    for k, r in databricks_user.all_users : k => r if contains(local.user_set, k)
  }
  group_id  = databricks_group.analysts.id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

##################################
# READ USERS
##################################

resource "databricks_group" "readonly" {
  display_name = "readonly"
}

data "azuread_group" "readonly" {
  display_name     = var.group_read
  security_enabled = true
}

data "azuread_users" "readonly" {
  object_ids     = toset(data.azuread_group.readonly.members)
  ignore_missing = true
}

locals {
  readonly_map = { for k, v in data.azuread_users.readonly.users : v.user_principal_name => v }
  readonly_set = toset(data.azuread_users.readonly.user_principal_names)
}

resource "databricks_group_member" "i-am-readonly" {
  for_each = {
    for k, r in databricks_user.all_users : k => r if contains(local.readonly_set, k)
  }
  group_id  = databricks_group.readonly.id
  member_id = each.value.id

  depends_on = [
    databricks_user.all_users
  ]
}

##################################
# ALL USERS CREATION
##################################
resource "databricks_user" "all_users" {
  for_each              = merge(local.readonly_map, local.user_map, local.admin_map)
  provider              = databricks
  user_name             = each.value.user_principal_name
  display_name          = each.value.display_name
  external_id           = each.value.object_id
  workspace_access      = true
  force                 = true
  databricks_sql_access = false
}


##################################
# DELIVERY SPNS
##################################

data "azuread_group" "app" {
  display_name     = var.group_admin
  security_enabled = true
}

data "azuread_service_principals" "admin" {
  object_ids     = toset(data.azuread_group.app.members)
  ignore_missing = true
}

resource "databricks_service_principal" "admins" {
  for_each       = local.app_map
  application_id = each.key
  display_name   = each.value
  force          = true
}

locals {
  # Alls SPN except creator SPN (current) who is already admin
  app_map = { for k, v in data.azuread_service_principals.admin.service_principals : v.application_id => v.display_name }
}

resource "databricks_group_member" "app-are-admin" {
  for_each = {
    for k, r in databricks_service_principal.admins : k => r
  }
  group_id  = data.databricks_group.admins.id
  member_id = each.value.id
}
