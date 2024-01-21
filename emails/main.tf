terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate-emails"
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

resource "azurerm_resource_group" "vnet_resource_group" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet_resource_group.location
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "vnet_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.subnet_address_prefix
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_storage_account" "vnet_storage_account" {
  name                     = var.vnet_storage_account_name
  resource_group_name      = azurerm_resource_group.vnet_resource_group.name
  location                 = azurerm_resource_group.vnet_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
    ip_rules                   = "84.110.136.18"
  }

}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_vault_secret_name
  value        = azurerm_storage_account.vnet_storage_account.primary_connection_string
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  location            = azurerm_storage_account.vnet_storage_account.location
  resource_group_name = azurerm_storage_account.vnet_storage_account.resource_group_name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_function_app" "linux_function_app" {
  name                       = var.function_app_name
  location                   = azurerm_storage_account.vnet_storage_account.location
  resource_group_name        = azurerm_storage_account.vnet_storage_account.resource_group_name
  service_plan_id        = azurerm_service_plan.service_plan.id
  storage_account_name       = azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = azurerm_storage_account.vnet_storage_account.primary_access_key
  functions_extension_version = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    EMAILS_SECRET = azurerm_key_vault_secret.key_vault_secret.name
    KEYVAULT_URI = data.azurerm_key_vault.key_vault.vault_uri
    https_only                                = true
    GRAPH_URL = " "
    CLIENT_ID	= " "
    CLIENT_SECRET = " "
    TENANT_ID = " "
    DOCKER_REGISTRY_SERVER_URL                = var.DOCKER_REGISTRY_SERVER_URL 
    DOCKER_REGISTRY_SERVER_USERNAME           = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD           = var.DOCKER_REGISTRY_SERVER_PASSWORD 
    WEBSITES_ENABLE_APP_SERVICE_STORAGE       = false
  }
  
  site_config {
    always_on         = true
    application_stack {
      docker {
        registry_url = var.DOCKER_REGISTRY_SERVER_URL
        image_name = var.IMAGE_NAME
        image_tag = var.IMAGE_TAG
        registry_username = var.DOCKER_REGISTRY_SERVER_USERNAME
        registry_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
      }
    }
  }

  identity {
    type = "SystemAssigned"
  }
  
}

resource "azurerm_linux_function_app_slot" "linux_function_app_slot" {
  name                       = "development"
  function_app_id            = azurerm_linux_function_app.linux_function_app.id
  storage_account_name       = azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = azurerm_storage_account.vnet_storage_account.primary_access_key
   site_config {
    always_on         = true
    application_stack {
      docker {
        registry_url = var.DOCKER_REGISTRY_SERVER_URL
        image_name = var.IMAGE_NAME
        image_tag = var.IMAGE_TAG
        registry_username = var.DOCKER_REGISTRY_SERVER_USERNAME
        registry_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
      }
    }
  }
}


data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault_access_policy" "principal" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current_client.tenant_id
  object_id    = azurerm_linux_function_app.linux_function_app.identity[0].principal_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]

  secret_permissions = [
    "Get",
  ]

}