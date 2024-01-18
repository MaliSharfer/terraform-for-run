variable subscription_id {
  type        = string
}

variable rg_name {
  type     = string
  default  = "rg-chaycycycy"
}

variable rg_location {  
  type     = string
  default  = "West Europe"
}

variable vnet_name {
  type      = string
  default   = "vnet-wow"
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
  default  = "snet-wow"
}

variable subnet_address_prefix {
  type     = list
  default  = ["10.1.1.0/24"]
}

variable vnet_storage_account_name {
  type     = string
  default  =  "stchyachaya"
}



variable table_name {
  type     = string
  default  =  "wowowow"
}
