variable subscription_id {
  type        = string
}

variable rg_name {
  type     = string
  default  = "rg-success"
}

variable rg_location {  
  type     = string
  default  = "West Europe"
}

variable vnet_name {
  type      = string
  default   = "vnet-success"
}

variable address_space {
  type     = list
  default  = ["10.1.0.0/16"]
}

variable dns_servers {
  type     = list
  default  = []
}

variable subnet_name {
  type     = string
  default  = "snet-success"
}

variable subnet_address_prefix {
  type     = list
  default  = ["10.1.1.0/24"]
}

variable vnet_storage_account_name {
  type     = string
  default  =  "success"
}

variable key_vault_name {
  type     = string
  default  = "kv-sucsses"
}

variable key_vault_sku_name {
  type     = string
  default  = "standard"
}

variable key_vault_certificate_permissions {
  type     = list
  default  = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]
}

variable key_vault_key_permissions {
  type     = list
  default  = ["Create","Get"]
}

variable key_vault_secret_permissions {
  type     = list
  default  = ["Get","Set","Delete","Purge","Recover"]
}

variable key_vault_storage_permissions {
  type     = list
  default  =  ["Get", ]
}

variable key_vault_secret_name {
  type        = string
  default     = "TRY-SECRET"
}

variable table_name {
  type     = string
  default  =  "success"
}

variable function_app_name {
  type = string
  default = "func-full-success"
}
