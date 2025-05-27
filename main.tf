locals {
  production = var.environment == "PRD" || var.environment == "PRE"

  users_group_name = "GRP_AZURE_DATA_${upper(var.data_scope)}_${local.production ? "PRD" : "NPD"}_USERS"
  read_group_name  = "GRP_AZURE_DATA_${upper(var.data_scope)}_${local.production ? "PRD" : "NPD"}_READERS"
}
