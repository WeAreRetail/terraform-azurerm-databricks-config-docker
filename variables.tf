variable "acr_url" {
  type        = string
  description = "The Azure Container Registry for the docker image."
}

variable "acr_uses_application_spn" {
  type        = bool
  description = "Whether or not the ACR uses an application service principal. If true the images pull will use the application service principal. If false, it will uses the well-known service principal."
  default     = true
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

variable "data_scope" {
  type = string
  validation {
    condition     = contains(["AWARE", "ITM", "LDIT", "MANAGEMENT", "NONE"], upper(var.data_scope))
    error_message = "${var.data_scope} is not a valid scope (AWARE, ITM, LDIT) or tech scope MANAGEMENT"
  }
  description = "The data scope of the Databricks workspace. It is used to determine the permissions."
  default     = "NONE"
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
  description = "Administrators user group (with no groups inside). Not required after Unity migration."
  default     = "set_if_unity_permissions_migration_is_true"
}

variable "group_read" {
  type        = string
  description = "Read only users user group (with no groups inside). Not required after Unity migration."
  default     = "set_if_unity_permissions_migration_is_true"
}

variable "group_user" {
  type        = string
  description = "Developers user group (with no groups inside). Not required after Unity migration."
  default     = "set_if_unity_permissions_migration_is_true"
}

variable "key_vault_id" {
  type        = string
  description = "The key vault id."
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

variable "telemetry_connection_string" {
  type        = string
  description = "The connection string to the telemetry."
  default     = "telemetry_not_set"
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID."
  default     = "8ca5b849-53e1-48cf-89fb-0103886af200"
}

variable "trigram" {
  type        = string
  description = "The project trigram."
}

variable "unity_enabled" {
  type        = bool
  default     = false
  description = "Decides whether unity is enabled or not, which changes the default policy attributes."
}

variable "unity_permissions" {
  type        = bool
  default     = false
  description = "Switch to the Unity permissions approach."
}

variable "unity_permissions_migration" {
  type        = string
  description = "During the migration to Unity permissions, both the old (flattened groups) and new permissions (Unity groups) are set."
  default     = true
}
