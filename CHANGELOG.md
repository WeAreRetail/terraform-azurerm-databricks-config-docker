# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - 2024-03-11

### Fixed availability of databricks pools

- Using "SPOT_AZURE" by bumping the policy version to be inline with the current databricks pools configuration


## [2.1.1] - 2024-03-04

### Changed

- upgraded databricks-policies-docker module to 1.1.0 to fix policy issues

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

- Initial Release to open source

## [1.1.0] - 2024-13-02

### Modified

- Name of databricks policy from latest to current
