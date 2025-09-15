# terraform-password-manager

Terraform module for managing active/backup password pairs with rotation and swapping.

## Quick start

```hcl
module "passwords" {
  source = "./"
  
  password_length = 16
  operation_mode = "regenerate_active"
}
```

## What it does

Generates two random passwords (active and backup) and lets you:
- Rotate the backup password without touching the active one
- Swap active and backup passwords
- Regenerate the active password
- Keep everything idempotent (no changes unless you ask for them)

## Operation modes

Set `operation_mode` to control what happens:

- `regenerate_active` - Generate a new active password
- `rotate_backup` - Generate a new backup password  
- `swap` - Switch active and backup passwords
- `normal` - Do nothing (default)

## Examples

### Generate both passwords
```hcl
module "active" {
  source = "./"
  operation_mode = "regenerate_active"
}

module "backup" {
  source = "./"
  operation_mode = "rotate_backup"
  current_active_password = module.active.active_password
  current_backup_password = module.active.backup_password
}
```

### Rotate backup password
```hcl
module "passwords" {
  source = "./"
  operation_mode = "rotate_backup"
  current_active_password = "keep_this_one"
  current_backup_password = "old_backup"
}
```

### Swap passwords
```hcl
module "passwords" {
  source = "./"
  operation_mode = "swap"
  current_active_password = "current_active"
  current_backup_password = "current_backup"
}
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `password_length` | number | 16 | Password length (8-128 chars) |
| `use_special_chars` | bool | true | Include special characters |
| `use_upper_case` | bool | true | Include uppercase letters |
| `use_lower_case` | bool | true | Include lowercase letters |
| `use_numeric` | bool | true | Include numbers |
| `operation_mode` | string | "normal" | What operation to perform |
| `current_active_password` | string | "" | Current active password (for idempotency) |
| `current_backup_password` | string | "" | Current backup password (for idempotency) |

## Outputs

- `active_password` - The active password
- `backup_password` - The backup password
- `info` - Some info about the passwords

## Requirements

- Terraform >= 1.0
- Random provider ~> 3.1

## How to run

### Quick test

```bash
cd examples
terraform init
terraform apply -auto-approve
terraform output -json passwords
```

### Complete example

Shows all operations: generation, rotation, and swapping.

```bash
cd examples
terraform init
terraform apply -auto-approve
terraform output -json initial_passwords
terraform output -json swapped_passwords
```

### Use in your project

```bash
# In your project directory
module "passwords" {
  source = "path/to/this/module"
  password_length = 16
  operation_mode = "regenerate_active"
}
```

## Notes

- Passwords are marked as sensitive
- Module is idempotent - won't regenerate unless you change `operation_mode`
- Can't rotate and swap at the same time (validation prevents this)
- Works with any Terraform provider setup
