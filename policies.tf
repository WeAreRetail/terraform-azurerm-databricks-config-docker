locals {
  databricks_policies_unity_disabled = var.unity_permissions_migration ? {
    for k, v in var.databricks_policies : k => {
      CAN_USE_GROUP      = v["CAN_USE_GROUP"]
      DATABRICKS_VERSION = v["DATABRICKS_VERSION"]
      IMAGE_NAME         = v["IMAGE_NAME"]
      IS_JOB_POLICY      = v["IS_JOB_POLICY"]
      POLICY_NAME        = v["POLICY_NAME"]
      POLICY_OVERRIDES   = v["POLICY_OVERRIDES"]
      POOL               = v["POOL"]
    }
  } : {}

  databricks_policies_unity_enabled = var.unity_enabled ? {
    for k, v in var.databricks_policies : "${k}Unity" => {
      CAN_USE_GROUP      = v["CAN_USE_GROUP"]
      DATABRICKS_VERSION = v["DATABRICKS_VERSION"]
      IMAGE_NAME         = v["IMAGE_NAME"]
      IS_JOB_POLICY      = v["IS_JOB_POLICY"]
      POLICY_NAME        = strcontains(v["POLICY_NAME"], " ") ? "${v["POLICY_NAME"]} - Unity" : "${v["POLICY_NAME"]}Unity"
      POLICY_OVERRIDES   = v["POLICY_OVERRIDES"]
      POOL               = v["POOL"]
    }
  } : {}
}


module "databricks_policies_unity_disabled" {
  source  = "WeAreRetail/databricks-policies-docker/azurerm"
  version = "3.1.2"

  for_each = local.databricks_policies_unity_disabled

  can_use_group            = each.value["CAN_USE_GROUP"]
  policy_name              = each.value["POLICY_NAME"]
  databricks_version       = each.value["DATABRICKS_VERSION"]
  docker_image_url         = "${var.acr_url}/${each.value["IMAGE_NAME"]}:${lower(var.environment)}-current"
  docker_spn_client_id     = var.acr_uses_application_spn ? "{{secrets/security/spn-id}}" : "{{secrets/registry/acr-username}}"
  docker_spn_client_secret = var.acr_uses_application_spn ? "{{secrets/security/acr-secret}}" : "{{secrets/registry/acr-password}}"
  is_job_policy            = each.value["IS_JOB_POLICY"]
  logs_path                = var.logs_path
  policy_overrides         = each.value["POLICY_OVERRIDES"]
  unity_enabled            = false
}

moved {
  from = module.databricks_policies
  to   = module.databricks_policies_unity_disabled
}

module "databricks_policies_unity_enabled" {
  source  = "WeAreRetail/databricks-policies-docker/azurerm"
  version = "3.1.2"

  for_each = local.databricks_policies_unity_enabled

  can_use_group            = each.value["CAN_USE_GROUP"]
  policy_name              = each.value["POLICY_NAME"]
  databricks_version       = each.value["DATABRICKS_VERSION"]
  docker_image_url         = "${var.acr_url}/${each.value["IMAGE_NAME"]}:${lower(var.environment)}-current"
  docker_spn_client_id     = var.acr_uses_application_spn ? "{{secrets/security/spn-id}}" : "{{secrets/registry/acr-username}}"
  docker_spn_client_secret = var.acr_uses_application_spn ? "{{secrets/security/acr-secret}}" : "{{secrets/registry/acr-password}}"
  is_job_policy            = each.value["IS_JOB_POLICY"]
  logs_path                = var.logs_path
  policy_overrides         = each.value["POLICY_OVERRIDES"]
  unity_enabled            = true
}


locals {

  databricks_policies_module_merged = merge(
    module.databricks_policies_unity_disabled,
    module.databricks_policies_unity_enabled
  )

  policy_id_map = {
    for policy_key, policy in local.databricks_policies_module_merged : policy_key => policy.policy_id
  }

  job_policy_id_unity_disabled = one(
    [for policy_key, policy in module.databricks_policies_unity_disabled : policy.policy_id if policy.is_job_policy]
  )

  job_policy_name_unity_disabled = one(
    [for policy_key, policy in module.databricks_policies_unity_disabled : policy.policy_name if policy.is_job_policy]
  )

  job_policy_key_unity_disabled = one(
    [for policy_key, policy in module.databricks_policies_unity_disabled : policy_key if policy.is_job_policy]
  )

  job_policy_id_unity_enabled = one(
    [for policy_key, policy in module.databricks_policies_unity_enabled : policy.policy_id if policy.is_job_policy]
  )

  job_policy_name_unity_enabled = one(
    [for policy_key, policy in module.databricks_policies_unity_enabled : policy.policy_name if policy.is_job_policy]
  )

  job_policy_key_unity_enabled = one(
    [for policy_key, policy in module.databricks_policies_unity_enabled : policy_key if policy.is_job_policy]
  )
}
