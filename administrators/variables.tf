variable rg_name {
  type     = string
  default  = "rg-administrators"
}

variable vnet_storage_account_name {
  type        = string
  default     = "stadministrators"
}

variable location {  
  type     = string
  default  = "West Europe"
}


variable key_vault_name {
  type     = string
  default  = "kv-connection-string1"
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
  default     = "ADMINISTRATORS-SECRET"
}

variable table_name {
  type     = string
  default  =  "administrators2"
}

variable virtual_networks_and_subnets_properties{
  default = [
    {
      vnet_name            = "vnet-administrators"
      resource_group_name  = "rg-administrators"
      address_space        = ["10.1.0.0/16"]
      snet_name            = "snet-administrators"
      address_prefixes     =  ["10.1.1.0/24"]
    },
    {
      vnet_name            = "vnet-emails"
      resource_group_name  = "rg-emails"
      address_space        = ["10.2.0.0/16"]
      snet_name            = "snet-emails"
      address_prefixes     =  ["10.2.1.0/24"]
    },
    {
      vnet_name           = "vnet-manage-subscriptions"
    resource_group_name = "rg-manage-subscrioptions"
      address_space       = ["10.3.0.0/16"]
      snet_name           = "snet-manage-subscriptions"
      address_prefixes    = ["10.3.1.0/24"]
    },
    {
      vnet_name           = "vnet-storages"
      resource_group_name = "rg-storages"
      address_space       = ["10.4.0.0/16"]
      snet_name           = "snet-storages"
      address_prefixes    = ["10.4.1.0/24"]
    },
  ]
}


# variable vnet_subnet {
#   default = [
#     {
#       name                 = "snet-administrators"
#       address_prefixes     =  ["10.1.1.0/24"]
#     },
#     {
#       name                 = "snet-emails"
#       address_prefixes     =  ["10.1.1.0/24"]
#     },
#     {
#       name                 = "snet-manage-subscriptions"
#       address_prefixes     = ["10.1.1.0/24"]
#     },
#     {
#       name                 = "snet-storages"
#       address_prefixes     = ["10.1.1.0/24"]
#     },
#   ]
# }


