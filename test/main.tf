# Test the password module

module "passwords" {
  source = "../"
  
  password_length = 16
  operation_mode = "regenerate_active"
}

output "passwords" {
  value = {
    active = module.passwords.active_password
    backup = module.passwords.backup_password
    metadata = module.passwords.metadata
  }
  sensitive = true
}
