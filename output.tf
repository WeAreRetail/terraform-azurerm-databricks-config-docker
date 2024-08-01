output "analyst_group_name" {
  value = databricks_group.analysts.display_name
}

output "databricks_group_analysts" {
  value       = databricks_group.analysts
  description = "Databricks Analysts group."
}

output "group_read_name" {
  value = databricks_group.readonly
}

output "job_policy_id" {
  value       = local.job_policy_id
  description = "The job policy ID if defined, else null."
}

output "job_policy_key" {
  value       = local.job_policy_key
  description = "The job policy key if defined, else null."
}

output "job_policy_name" {
  value       = local.job_policy_name
  description = "The job policy name if defined, else null."
}

output "pool_databricks_runtime" {
  value       = local.pool_to_enable["DATABRICKS_VERSION"]
  description = "The pools' Databricks runtime version."
}

output "pool_spot_ids" {
  value = {
    for name, pool in module.pools : name => pool.pool_spot_id
  }
  description = "The warm pool id"
}

output "pool_warm_ids" {
  value = {
    for name, pool in module.pools : name => pool.pool_warm_id
  }
  description = "The spot pool id"
}

output "policy_ids" {
  value       = local.policy_id_map
  description = "Map of the policy IDs that have been created. The key is the policy key and the value is the policy ID."
}

output "security_scope" {
  value       = databricks_secret_scope.security.name
  description = "Databricks security scope name."
}

output "spn_id_value" {
  value       = data.azurerm_key_vault_secret.spn_id.value
  description = "SPN ID value"
}

output "spn_secret_key" {
  value       = databricks_secret.spn_secret.key
  description = "SPN Secret key."
}
