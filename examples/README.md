# Examples

Working examples of the password module.

## Basic

```bash
cd examples
terraform init
terraform apply -auto-approve
terraform output -json passwords
```

## Complete workflow

Shows generation, rotation, and swapping.

```bash
cd examples
terraform init
terraform apply -auto-approve
terraform output -json initial_passwords
terraform output -json swapped_passwords
```

## Usage patterns

### Generate active password
```hcl
module "passwords" {
  source = "../"
  operation_mode = "regenerate_active"
}
```

### Rotate backup
```hcl
module "passwords" {
  source = "../"
  operation_mode = "rotate_backup"
  current_active_password = "existing_active"
  current_backup_password = "existing_backup"
}
```

### Swap passwords
```hcl
module "passwords" {
  source = "../"
  operation_mode = "swap"
  current_active_password = "current_active"
  current_backup_password = "current_backup"
}
```
