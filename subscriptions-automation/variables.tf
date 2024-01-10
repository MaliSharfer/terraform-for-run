variable subscription_id {
  type        = string
}

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
  default = "rg-manage-subscrioptions"
}

variable rg_location {  
  type        = string
  default = "West Europe"
}

variable vnet_name {
  type        = string
  default = "vnet-manage-subscriptions"
}

variable address_space {
  type        = list
  default = ["10.1.0.0/16"]
}

variable dns_servers {
  type        = list
  default = []
}

variable subnet_name {
  type        = string
  default = "snet-manage-subscriptions"
}

variable subnet_address_prefix {
  type    = list
  default = ["10.1.1.0/24"]
}

variable vnet_storage_account_name {
  type    = string
  default =  "stmanageaubscriptions"
}

variable app_service_plan_name{
  type    = list(string)
  default =  ["app-subscriptions-automation","app-subscriptions-list"]
}

variable function_app_name {
  type    = list(string)
  default =  ["func-subscriptions-automation" , "func-subscriptions-list" ]
}

variable logic_app_workflow_name {
  type        = string
  default = "logic-app-subscription-management"
}

variable key_vault_name {
  type        = string
  default = "kv-connection-string"
}

variable key_vault_uri {
  type        = string
  default     = "https://kv-manage-automation.vault.azure.net"
}

variable key_vault_resource_group_name {
  type     = string
  default  = "rg-administrators"
}

variable key_vault_secret_name {
  type        = string
  default     = "SUBSCRIPTION-SECRET"
}

variable linux_fx_version {
  type = string
  default = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart"
}

variable table_name {
  type     = list(string)
  default =  ["deletedSubscriptions","subscriptionsToDelete","emails"]
}