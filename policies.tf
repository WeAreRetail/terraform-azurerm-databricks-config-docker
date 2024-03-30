module "databricks_policies" {
  source  = "WeAreRetail/databricks-policies-docker/azurerm"
  version = "1.5.1"

  for_each = var.databricks_policies

  can_use_group            = each.value["CAN_USE_GROUP"]
  policy_name              = each.value["POLICY_NAME"]
  databricks_version       = each.value["DATABRICKS_VERSION"]
  docker_image_url         = "${var.acr_url}/${each.value["IMAGE_NAME"]}:${lower(var.environment)}-current"
  docker_spn_client_id     = data.azurerm_key_vault_secret.spn_id.value
  docker_spn_client_secret = data.azurerm_key_vault_secret.spn_secret.value
  is_job_policy            = each.value["IS_JOB_POLICY"]
  logs_path                = var.logs_path
  policy_overrides         = each.value["POLICY_OVERRIDES"]
}

locals {
  policy_id_map = {
    for policy_key, policy in module.databricks_policies : policy_key => policy.policy_id
  }

  job_policy_id = one(
    [for policy_key, policy in module.databricks_policies : policy.policy_id if policy.is_job_policy]
  )

  job_policy_name = one(
    [for policy_key, policy in module.databricks_policies : policy.policy_name if policy.is_job_policy]
  )

  job_policy_key = one(
    [for policy_key, policy in module.databricks_policies : policy_key if policy.is_job_policy]
  )
}
