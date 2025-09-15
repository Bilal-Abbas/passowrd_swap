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
  regenerate_active = var.operation_mode == "regenerate_active"
  regenerate_backup = var.operation_mode == "rotate_backup"
  swap_passwords = var.operation_mode == "swap"
}

resource "random_password" "active" {
  count = local.regenerate_active ? 1 : 0
  
  length  = var.password_length
  special = var.use_special_chars
  upper   = var.use_upper_case
  lower   = var.use_lower_case
  numeric = var.use_numeric
}

resource "random_password" "backup" {
  count = local.regenerate_backup ? 1 : 0
  
  length  = var.password_length
  special = var.use_special_chars
  upper   = var.use_upper_case
  lower   = var.use_lower_case
  numeric = var.use_numeric
}

locals {
  active_pwd = local.regenerate_active ? random_password.active[0].result : var.current_active_password
  backup_pwd = local.regenerate_backup ? random_password.backup[0].result : var.current_backup_password
  
  final_active = local.swap_passwords ? local.backup_pwd : local.active_pwd
  final_backup = local.swap_passwords ? local.active_pwd : local.backup_pwd
}

output "active_password" {
  value     = local.final_active
  sensitive = true
}

output "backup_password" {
  value     = local.final_backup
  sensitive = true
}

output "metadata" {
  value = {
    active_length = length(local.final_active)
    backup_length = length(local.final_backup)
    last_updated  = timestamp()
    operation = var.operation_mode
  }
}
