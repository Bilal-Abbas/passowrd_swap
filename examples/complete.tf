module "active" {
  source = "../"
  
  password_length = 12
  operation_mode = "regenerate_active"
}

module "backup" {
  source = "../"
  
  password_length = 12
  operation_mode = "rotate_backup"
  
  current_active_password = module.active.active_password
  current_backup_password = module.active.backup_password
}

module "swapped" {
  source = "../"
  
  password_length = 12
  operation_mode = "swap"
  
  current_active_password = module.backup.active_password
  current_backup_password = module.backup.backup_password
}

output "initial_passwords" {
  value = {
    active = module.backup.active_password
    backup = module.backup.backup_password
  }
  sensitive = true
}

output "swapped_passwords" {
  value = {
    active = module.swapped.active_password
    backup = module.swapped.backup_password
  }
  sensitive = true
}
