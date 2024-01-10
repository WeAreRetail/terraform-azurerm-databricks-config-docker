locals {
  pool_to_enable = one([
    for key, value in var.databricks_policies : value
    if value["POOL"]
  ])
}


module "pools" {
  source  = "WeAreRetail/databricks-pools-docker/azurerm"
  version = "1.0.0"

  databricks_version       = local.pool_to_enable["DATABRICKS_VERSION"]
  docker_image_url         = "${var.acr_url}/${local.pool_to_enable["IMAGE_NAME"]}:${lower(var.environment)}-latest"
  docker_spn_client_id     = data.azurerm_key_vault_secret.spn_id.value
  docker_spn_client_secret = data.azurerm_key_vault_secret.spn_secret.value
  environment              = var.environment
  spot_pool_name           = "spot_pool"
  warm_pool_name           = "warm_pool"
}
