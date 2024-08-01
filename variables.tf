variable "acr_url" {
  type        = string
  description = "The Azure Container Registry for the docker image."
}

variable "add_apps_in_groups" {
  type        = bool
  description = "Whether or not to add the applications in the groups. If false, the applications will only be added in the admin group."
  default     = false

}

variable "allow_pat_config" {
  type        = bool
  description = "Whether or not to allow the usage of PATs to configure databricks"
  default     = false
}

variable "databricks_policies" {
  type = map(object(
    {
      CAN_USE_GROUP      = string
      DATABRICKS_VERSION = string
      IMAGE_NAME         = string
      IS_JOB_POLICY      = optional(bool, false)
      POLICY_NAME        = string
      POOL               = optional(bool, false)
      POLICY_OVERRIDES   = optional(any, {})
    }
  ))
  description = "The Databricks clusters policies."

  # Example of how to use the variable
  #
  # databricks_policies = {
  #   "databricks_12_2" = {
  #     "CAN_USE_GROUP"      = "analysts",
  #     "DATABRICKS_VERSION" = "12.2.x-scala2.12"
  #     "IMAGE_NAME"         = "databricks12",
  #     "POLICY_NAME"        = "Analysts cluster policy - 12.2-LTS",
  #     "POOL"               = false #Enable only one pool
  #     "POLICY_OVERRIDES" = {
  #       "autotermination_minutes" : {
  #         "type" : "fixed",
  #         "value" : 45,
  #         "hidden" : false
  #       },
  #     }
  #   },
  #   "databricks_13_3" = {
  #     "CAN_USE_GROUP"      = "analysts",
  #     "DATABRICKS_VERSION" = "13.3.x-scala2.12",
  #     "IMAGE_NAME"         = "databricks13",
  #     "POLICY_NAME"        = "Analysts cluster policy - 13.3-LTS",
  #     "POOL"               = false #Enable only one pool
  #     "POLICY_OVERRIDES" = {
  #       "autotermination_minutes" : {
  #         "type" : "fixed",
  #         "value" : 45,
  #         "hidden" : false
  #       }
  #     }
  #   }
  # }

  validation {

    condition = length(
      [
        for key, value in var.databricks_policies : value
        if value["POOL"]
      ]
    ) == 1

    error_message = "One and only one policy with pool enabled"
  }

  validation {

    condition = length(
      [
        for key, value in var.databricks_policies : value
        if value["IS_JOB_POLICY"]
      ]
    ) <= 1

    error_message = "Maximum one job policy can be defined"
  }
}

variable "environment" {
  type        = string
  description = "The infrastructure environment."
}

variable "group_admin" {
  type        = string
  description = "Administrators user group (with no groups inside)."
}

variable "group_read" {
  type        = string
  description = "Read only users user group (with no groups inside)."
}

variable "group_user" {
  type        = string
  description = "Developpers user group (with no groups inside)."
}

variable "key_vault_id" {
  type = string
}

variable "logs_path" {
  type        = string
  description = "The clusters logs root folder."
  default     = ""
}

variable "pools" {
  description = "Pool definition."
  type = map(object({
    spot_pool_max_capacity = number
    spot_pool_name         = string
    spot_pool_sku          = string
    warm_pool_max_capacity = number
    warm_pool_name         = string
    warm_pool_sku          = string
  }))
}

variable "tenant_id" {
  type        = string
  description = "Tenand ID."
  default     = "8ca5b849-53e1-48cf-89fb-0103886af200"
}

variable "trigram" {
  type        = string
  description = "The project trigram."
}

