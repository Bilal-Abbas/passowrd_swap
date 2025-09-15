terraform {
  required_version = ">= 1.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

locals {
  should_gen_active = var.operation_mode == "regenerate_active"
  should_gen_backup = var.operation_mode == "rotate_backup"
  should_swap = var.operation_mode == "swap"
}

resource "random_password" "active" {
  count = local.should_gen_active ? 1 : 0
  
  length  = var.password_length
  special = var.use_special_chars
  upper   = var.use_upper_case
  lower   = var.use_lower_case
  numeric = var.use_numeric
}

resource "random_password" "backup" {
  count = local.should_gen_backup ? 1 : 0
  
  length  = var.password_length
  special = var.use_special_chars
  upper   = var.use_upper_case
  lower   = var.use_lower_case
  numeric = var.use_numeric
}

locals {
  current_active = local.should_gen_active ? random_password.active[0].result : var.current_active_password
  current_backup = local.should_gen_backup ? random_password.backup[0].result : var.current_backup_password
  
  active = local.should_swap ? local.current_backup : local.current_active
  backup = local.should_swap ? local.current_active : local.current_backup
}

output "active_password" {
  value     = local.active
  sensitive = true
}

output "backup_password" {
  value     = local.backup
  sensitive = true
}

output "info" {
  value = {
    active_len = length(local.active)
    backup_len = length(local.backup)
    updated = timestamp()
    mode = var.operation_mode
  }
}
