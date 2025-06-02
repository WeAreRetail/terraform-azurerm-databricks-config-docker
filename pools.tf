locals {
  pool_databricks_policy = one([
    for key, value in var.databricks_policies : value
    if value["POOL"]
  ])
}


module "pools" {
  source   = "WeAreRetail/databricks-pools-docker/azurerm"
  version  = "2.0.0"
  for_each = var.pools

  databricks_version       = local.pool_databricks_policy["DATABRICKS_VERSION"]
  docker_image_url         = "${var.acr_url}/${local.pool_databricks_policy["IMAGE_NAME"]}:${lower(var.environment)}-current"
  docker_spn_client_id     = var.acr_uses_application_spn ? "{{secrets/security/spn-id}}" : "{{secrets/registry/acr-username}}"
  docker_spn_client_secret = var.acr_uses_application_spn ? "{{secrets/security/acr-secret}}" : "{{secrets/registry/acr-password}}"
  spot_pool_max_capacity   = each.value.spot_pool_max_capacity
  spot_pool_name           = each.value.spot_pool_name
  spot_pool_sku            = each.value.spot_pool_sku
  warm_pool_max_capacity   = each.value.warm_pool_max_capacity
  warm_pool_name           = each.value.warm_pool_name
  warm_pool_sku            = each.value.warm_pool_sku
}
