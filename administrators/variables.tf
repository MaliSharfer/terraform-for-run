variable rg_name {
  type     = string
  default  = "rg-rimon"
}

variable vnet_storage_account_name {
  type        = string
  default     = "rimon"
}

variable location {  
  type     = string
  default  = "West Europe"
}


variable key_vault_name {
  type     = string
  default  = "kv-connection-rimon"
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
  default     = "RIMON-SECRET"
}

variable table_name {
  type     = string
  default  =  "rimontable"
}

variable virtual_networks_and_subnets_properties{
  default = [
    {
      vnet_name            = "vnet-rimon"
      resource_group_name  = "rg-rimon"
      address_space        = ["10.1.0.0/16"]
      snet_name            = "snet-rimon"
      address_prefixes     =  ["10.1.1.0/24"]
    },
    {
      vnet_name            = "vnet-try1"
      resource_group_name  = "rg-try1"
      address_space        = ["10.2.0.0/16"]
      snet_name            = "snet-try1"
      address_prefixes     =  ["10.2.1.0/24"]
    },
    {
      vnet_name           = "vnet-manage-try2"
      resource_group_name = "rg-manage-try2"
      address_space       = ["10.3.0.0/16"]
      snet_name           = "snet-manage-try2"
      address_prefixes    = ["10.3.1.0/24"]
    },
    {
      vnet_name           = "vnet-try3"
      resource_group_name = "rg-try3"
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


