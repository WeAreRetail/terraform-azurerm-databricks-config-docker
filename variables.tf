variable "acr_url" {
  type        = string
  description = "The Azure Container Registry for the docker image."
}

variable "databricks_policies" {
  type = map(object(
    {
      CAN_USE_GROUP      = string
      DATABRICKS_VERSION = string
      IMAGE_NAME         = string
      POLICY_NAME        = string
      POOL               = bool
      POLICY_OVERRIDES   = any
    }
  ))
  description = "The Databricks clusters policies."
  default = {
    "databricks_12_2" = {
      "CAN_USE_GROUP"      = "analysts",
      "DATABRICKS_VERSION" = "12.2.x-scala2.12"
      "IMAGE_NAME"         = "databricks12",
      "POLICY_NAME"        = "Analysts cluster policy - 12.2-LTS",
      "POOL"               = false #Enable only one pool
      "POLICY_OVERRIDES" = {
        "autotermination_minutes" : {
          "type" : "fixed",
          "value" : 45,
          "hidden" : false
        },
      }
    },
    "databricks_13_3" = {
      "CAN_USE_GROUP"      = "analysts",
      "DATABRICKS_VERSION" = "13.3.x-scala2.12",
      "IMAGE_NAME"         = "databricks13",
      "POLICY_NAME"        = "Analysts cluster policy - 13.3-LTS",
      "POOL"               = false #Enable only one pool
      "POLICY_OVERRIDES" = {
        "autotermination_minutes" : {
          "type" : "fixed",
          "value" : 45,
          "hidden" : false
        },
      }
    },
    "databricks_latest" = {
      "CAN_USE_GROUP"      = "analysts",
      "DATABRICKS_VERSION" = "12.2.x-scala2.12",
      "IMAGE_NAME"         = "databricks-latest",
      "POLICY_NAME"        = "Analysts cluster policy - Latest",
      "POOL"               = true #Enable only one pool
      "POLICY_OVERRIDES" = {
        "autotermination_minutes" : {
          "type" : "fixed",
          "value" : 45,
          "hidden" : false
        },
      }
    }
    "databricks_job_latest" = {
      "CAN_USE_GROUP"      = "analysts",
      "DATABRICKS_VERSION" = "12.2.x-scala2.12",
      "IMAGE_NAME"         = "databricks-latest",
      "POLICY_NAME"        = "Job cluster policy - Latest",
      "POOL"               = false #Enable only one pool,
      "POLICY_OVERRIDES"   = {}
    }
  }

  validation {

    condition = length(
      [
        for key, value in var.databricks_policies : value
        if value["POOL"]
      ]
    ) == 1

    error_message = "Only one policy with pool enabled"
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

variable "policy_overrides" {
  description = "Cluster policy overrides"
  default     = {}
}

variable "tenant_id" {
  type        = string
  description = "Tenand ID."
  default     = "8ca5b849-53e1-48cf-89fb-0103886af200"
}
