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

# variable vnet_name {
#   type        = string
#   default = "vnet-manage-subscriptions"
# }

variable address_space {
  type        = list
  default = ["10.1.0.0/16"]
}

variable dns_servers {
  type        = list
  default = []
}

variable vnet_rg_name {
  type     = string
  default  = "rg-administrators"
}

variable subnet_name {
  type     = string
  default  = "snet-administrators"
}

variable vnet_name {
  type      = string
  default   = "vnet-administrators"
}

variable vnet_storage_account_name {
  type    = string
  default =  "stmanageaubscriptions"
}

variable service_plan_name{
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
  default = "kv-connection-string1"
}

variable key_vault_resource_group_name {
  type     = string
  default  = "rg-administrators"
}

variable key_vault_secret_name {
  type        = string
  default     = "SUBSCRIPTION-SECRET"
}

variable IMAGE_NAME {
  type     = string
  default  = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type     = string
  default  = "4-appservice-quickstart"
}

variable table_name {
  type    = list(string)
  default =  ["deletedSubscriptions","subscriptionsToDelete","emails"]
}


