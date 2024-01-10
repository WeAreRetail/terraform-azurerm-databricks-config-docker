locals {
  production = var.environment == "PRD" || var.environment == "PRE"
}
