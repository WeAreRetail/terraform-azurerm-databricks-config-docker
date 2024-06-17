***Autogenerated file - do not edit***

#### Requirements

#### Inputs

#### Outputs

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.0.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | >= 1.2.16 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.0.0 |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_url"></a> [acr\_url](#input\_acr\_url) | The Azure Container Registry for the docker image. | `string` | n/a | yes |
| <a name="input_databricks_policies"></a> [databricks\_policies](#input\_databricks\_policies) | The Databricks clusters policies. | <pre>map(object(<br>    {<br>      CAN_USE_GROUP      = string<br>      DATABRICKS_VERSION = string<br>      IMAGE_NAME         = string<br>      IS_JOB_POLICY      = optional(bool, false)<br>      POLICY_NAME        = string<br>      POOL               = optional(bool, false)<br>      POLICY_OVERRIDES   = optional(any, {})<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The infrastructure environment. | `string` | n/a | yes |
| <a name="input_group_admin"></a> [group\_admin](#input\_group\_admin) | Administrators user group (with no groups inside). | `string` | n/a | yes |
| <a name="input_group_read"></a> [group\_read](#input\_group\_read) | Read only users user group (with no groups inside). | `string` | n/a | yes |
| <a name="input_group_user"></a> [group\_user](#input\_group\_user) | Developpers user group (with no groups inside). | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | n/a | `string` | n/a | yes |
| <a name="input_trigram"></a> [trigram](#input\_trigram) | The project trigram. | `string` | n/a | yes |
| <a name="input_add_apps_in_groups"></a> [add\_apps\_in\_groups](#input\_add\_apps\_in\_groups) | Whether or not to add the applications in the groups. If false, the applications will only be added in the admin group. | `bool` | `false` | no |
| <a name="input_allow_pat_config"></a> [allow\_pat\_config](#input\_allow\_pat\_config) | Whether or not to allow the usage of PATs to configure databricks | `bool` | `false` | no |
| <a name="input_logs_path"></a> [logs\_path](#input\_logs\_path) | The clusters logs root folder. | `string` | `""` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenand ID. | `string` | `"8ca5b849-53e1-48cf-89fb-0103886af200"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_analyst_group_name"></a> [analyst\_group\_name](#output\_analyst\_group\_name) | n/a |
| <a name="output_databricks_group_analysts"></a> [databricks\_group\_analysts](#output\_databricks\_group\_analysts) | Databricks Analysts group. |
| <a name="output_group_read_name"></a> [group\_read\_name](#output\_group\_read\_name) | n/a |
| <a name="output_job_policy_id"></a> [job\_policy\_id](#output\_job\_policy\_id) | The job policy ID if defined, else null. |
| <a name="output_job_policy_key"></a> [job\_policy\_key](#output\_job\_policy\_key) | The job policy key if defined, else null. |
| <a name="output_job_policy_name"></a> [job\_policy\_name](#output\_job\_policy\_name) | The job policy name if defined, else null. |
| <a name="output_policy_ids"></a> [policy\_ids](#output\_policy\_ids) | Map of the policy IDs that have been created. The key is the policy key and the value is the policy ID. |
| <a name="output_pool_databricks_runtime"></a> [pool\_databricks\_runtime](#output\_pool\_databricks\_runtime) | The pools' Databricks runtime version. |
| <a name="output_pool_spot_id"></a> [pool\_spot\_id](#output\_pool\_spot\_id) | The warm pool id |
| <a name="output_pool_warm_id"></a> [pool\_warm\_id](#output\_pool\_warm\_id) | The spot pool id |
| <a name="output_security_scope"></a> [security\_scope](#output\_security\_scope) | Databricks security scope name. |
| <a name="output_spn_id_value"></a> [spn\_id\_value](#output\_spn\_id\_value) | SPN ID value |
| <a name="output_spn_secret_key"></a> [spn\_secret\_key](#output\_spn\_secret\_key) | SPN Secret key. |
<!-- END_TF_DOCS -->
