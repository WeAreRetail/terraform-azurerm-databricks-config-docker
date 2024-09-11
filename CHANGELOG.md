
<!-- markdownlint-disable-file MD024 MD041 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.1.0] - 2024-09-11

- Bump `databricks-policies-docker`

## [5.0.0] - 2024-07-26

### Added

- Databricks pools to create must be specified.

### Updated

- Databricks pool modules.

## [4.3.0] - 2024-06-06

### Added

Optionally add applications to `readonly` and `analysts` groups. Controlled by `add_apps_in_groups`.
Default to false.

## [4.2.0] - 2024-06-06

### Fixed

Remove create before destroy.

## [4.1.0] - 2024-05-22

### Added

Static SPN secret.
Reference to secrets for docker credentials so that rotations don't break clusters anymore.

## [4.0.0] - 2024-05-10

### Added

Add a metadata store to hold the project trigram and the runtime environment.

### How to migrate

Add the `trigram` variable containing the project trigram to the module.

## [3.0.0] - 2024-04-08

### Breaking change

Disable Photon by default. Due to `WeAreRetail/databricks-policies-docker/azurerm` update.

### Fix

Rollback `policy_overrides` variable type to `any` as Terraform converts numbers to strings when mixing map and JSON.

## [2.5.1] - 2024-03-30

## Fixed

`IS_JOB_POLICY` was not passed to the policy module.

## [2.5.0] - 2024-03-30

### Add an option for differentiating a policy dedicated to the jobs

- Add the `IS_JOB_POLICY` option in the `databricks_policies`

The policy ID is exported with a dedicated `job_policy_id` output
Only one `IS_JOB_POLICY` can be true.

## [2.4.0] - 2024-03-21

### Using the new Databricks policies version

- Hide credentials for ACR
- Allow the usage of warm and spot pool cluster types

## [2.3.0] - 2024-03-19

### Added Databricks 14

- Defined Databricks 14 policy

## [2.2.0] - 2024-03-11

### Fixed availability of Databricks pools

- Using "SPOT_AZURE" by bumping the policy version to be in line with the current Databricks pools configuration

## [2.1.1] - 2024-03-04

### Changed

- upgraded `databricks-policies-docker` module to 1.1.0 to fix policy issues

## [2.1.0] - 2024-02-13

### Added

- Fix policy to use current instead of latest

## [2.0.0] - 2024-01-18

### Added

- You can now specify whether or not you wish to use PAT tokens for configuration, by using the `allow_pat_config` variable

### Changed

- WebTerminal is now disabled, was enabled previously
- FileStore Endpoint is now disabled, was not specified previously

## [1.0.0] - 2024-01-10

### Added

- Initial Release to Open Source

## [1.1.0] - 2024-13-02

### Modified

- Name of the Databricks policy from latest to current
