terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate-administraitors"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

data "azurerm_storage_account" "myfirsttrail"{
  name = "myfirsttrail"
  resource_group_name = "NetworkWatcherRG"
}


data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = "West Europe"
  resource_group_name         = data.azurerm_storage_account.myfirsttrail.resource_group_name
  soft_delete_retention_days  = 7
  tenant_id                   = data.azurerm_client_config.current_client.tenant_id
  sku_name                    = var.key_vault_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current_client.tenant_id
    object_id = data.azurerm_client_config.current_client.object_id

    certificate_permissions = var.key_vault_certificate_permissions

    key_permissions = var.key_vault_key_permissions

    secret_permissions = var.key_vault_secret_permissions

    storage_permissions = var.key_vault_storage_permissions
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_vault_secret_name
  value        = "12345"
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "service-plan-name"
  location            = "West Europe"
  resource_group_name = data.azurerm_storage_account.myfirsttrail.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Premium"
    size = "P1V2"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "function-app-name"
  location                   = "West Europe"
  resource_group_name        =  data.azurerm_storage_account.myfirsttrail.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  storage_account_name       = data.azurerm_storage_account.myfirsttrail.name
  storage_account_access_key = data.azurerm_storage_account.myfirsttrail.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
  
  site_config {
    always_on         = true
    linux_fx_version  = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart"
  }

  identity {
    type = "SystemAssigned"
  }
  
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current_client.tenant_id
  object_id    = data.azurerm_client_config.current_client.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

# data "azuread_service_principal" "example" {
#   display_name = "example-app"
# }

resource "azurerm_key_vault_access_policy" "example-principal" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current_client.tenant_id
  object_id  = azurerm_function_app.function_app.identity[0].object_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]
}


 
#   principal_id         = azurerm_function_app.example.identity[0].principal_id


# resource "azurerm_storage_table" "storage_table" {
#   name                 = var.table_name
#   storage_account_name = azurerm_storage_account.vnet_storage_account.name
# }
