variable key_vault_name {
  type = string
}

variable key_vault_resource_group_name {
  type = string
}

variable key_vault_secret_excel_name {
  type = string
}

variable rg_name{
  type    = string
  default ="rg-three"
}

variable rg_location {  
  type     = string
  default  = "West Europe"
}

variable storage_account_name {
  type        = string
  default =  "stthree"
}

variable key_vault_secret_name {
  type        = string
  default     = "CONNECTION-STRING-THREE"
}


variable app_service_plan_name{
  type = list(string)
  default = ["app-three-01","app-three-02","app-three-03","app-three-04","app-three-05"]
}

variable function_app_name {
  type        = list(string)
  default = ["func-three-01","func-three-02","func-three-03","func-three-04","func-three-05"]
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


variable IMAGE_NAME {
  type        = string
  default     = "mcr.microsoft.com/azure-functions/dotnet"
}

variable IMAGE_TAG {
  type        = string
  default     = "4-appservice-quickstart"
}

variable FREQ_AUTOMATION_TEST_TYPE {
  type        = string
  default = "Week"
  validation {
    condition     = contains(["Month","Week","Day","Hour","Minute","Second"], var.FREQ_AUTOMATION_TEST_TYPE)
    error_message = "Valid values for var: FREQ_AUTOMATION_TEST_TYPE are (Month,Week,Day,Hour,Minute,Second)."
  } 
}

variable FREQ_AUTOMATION_TEST_NUMBER {
  type        = number
  default = 1
}

variable logic_app_workflow_name {
  type        = string
  default = "logic-app-three"
}

variable table_name {
  type = list(string)
  default = [ "table1","table2","table3" ]
}
