variable DOCKER_REGISTRY_SERVER_PASSWORD {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_USERNAME {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_URL {
  type        = string
}

variable rg_name {
  type        = string
}

variable rg_location {  
  type        = string
}

variable vnet_subnet_id {  
  type        = string
}

variable vnet_storage_account_name {
  type    = string
  default =  "stchangenames1"
}

variable key_vault_name {
  type        = string
}

variable key_vault_resource_group_name{
  type        = string
}

variable service_plan_name{
  type    = list(string)
  default =  ["app-try1","app-ty3"]
}

variable function_app_name {
  type    = list(string)
  default =  ["func-try1" , "func-try3" ]
}

variable logic_app_workflow_name {
  type        = string
  default = "logic-app-try"
}

variable key_vault_secret_name {
  type        = string
  default     = "TRY3-SECRET"
}

variable table_name {
  type    = list(string)
  default =  ["deletedSubscriptionstry","subscriptionsToDeletetry","emailstry"]
}

variable IMAGE_NAME {
  type     = string
  default  = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type     = string
  default  = "4-appservice-quickstart"
}

