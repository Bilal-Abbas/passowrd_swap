variable "password_length" {
  type        = number
  default     = 16
  validation {
    condition     = var.password_length >= 8 && var.password_length <= 128
    error_message = "Password length must be between 8 and 128 characters."
  }
}

variable "use_special_chars" {
  type    = bool
  default = true
}

variable "use_upper_case" {
  type    = bool
  default = true
}

variable "use_lower_case" {
  type    = bool
  default = true
}

variable "use_numeric" {
  type    = bool
  default = true
}

variable "current_active_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "current_backup_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "operation_mode" {
  type    = string
  default = "normal"
  validation {
    condition = contains([
      "normal",
      "rotate_backup", 
      "swap",
      "regenerate_active"
    ], var.operation_mode)
    error_message = "Operation mode must be one of: normal, rotate_backup, swap, regenerate_active."
  }
}
