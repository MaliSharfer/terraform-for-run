variable DOCKER_REGISTRY_SERVER_URL {
  type = string
}

variable DOCKER_REGISTRY_SERVER_USERNAME {
  type = string
}

variable DOCKER_REGISTRY_SERVER_PASSWORD {
  type = string
}

variable key_vault_name {
  type = string
}

variable key_vault_resource_group_name{
  type = string
}

variable rg_name{
  type    = string
  default ="rg-tow"
}

variable rg_location {  
  type     = string
  default  = "West Europe"
}

variable storage_account_name {
  type    = string
  default = "sttow"
}

variable key_vault_secret_name {
  type    = string
  default = "TOW-SECRET"
}

variable service_plan_name{
  type    = string
  default = "app-tow"
}

variable function_app_name {
  type    = string
  default = "func-tow"
}

variable IMAGE_NAME {
  type    = string
  default = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type    = string
  default = "4-appservice-quickstart"
}
