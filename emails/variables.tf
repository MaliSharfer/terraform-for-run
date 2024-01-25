
variable DOCKER_REGISTRY_SERVER_URL {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_USERNAME {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_PASSWORD {
  type        = string
}

variable rg_name {
  type     = string
}

variable rg_location {  
  type     = string
}

variable vnet_subnet_id {
  type        = string
}

variable key_vault_name {
  type        = string
}

variable key_vault_resource_group_name{
  type        = string
}

variable vnet_storage_account_name {
  type      = string
  default   =  "stemails"
}

variable key_vault_secret_name {
  type      = string
  default   = "EMAILS-SECRET"
}


variable service_plan_name{
  type     = string
  default  = "app-emails"
}

variable function_app_name {
  type     = string
  default  = "func-emails"
}


variable IMAGE_NAME {
  type        = string
  default     = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type        = string
  default     = "4-appservice-quickstart"
}