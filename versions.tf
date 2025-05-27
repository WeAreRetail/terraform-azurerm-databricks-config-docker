terraform {
  required_version = ">= 1.2.0"
  required_providers {

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.2"
    }

    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.2.16"
    }

    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
    }
  }
}
