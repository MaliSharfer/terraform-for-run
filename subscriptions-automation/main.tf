terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate-subscriptions"
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
  name                = var.vnet_storage_account_name
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  location                 = azurerm_resource_group.vnet_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # network_rules {
  #   default_action             = "Deny"
  #   virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
  #   ip_rules                   = ["84.110.136.18"]
  # }

}

resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id    = azurerm_storage_account.vnet_storage_account.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
  ip_rules                   = ["84.110.136.18"]
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

resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                =  var.logic_app_workflow_name
  location            = azurerm_resource_group.vnet_resource_group.location
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
}

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name[count.index]
  location            = azurerm_storage_account.vnet_storage_account.location
  resource_group_name = azurerm_storage_account.vnet_storage_account.resource_group_name
  os_type             = "Linux"
  sku_name            = "P1v2"

  count = length(var.service_plan_name)  
}

resource "azurerm_linux_function_app" "function_app" {
  name                      = var.function_app_name[count.index]
  location                  = azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = azurerm_storage_account.vnet_storage_account.resource_group_name
  service_plan_id       = azurerm_service_plan.service_plan[count.index].id
  storage_account_name      = azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = azurerm_storage_account.vnet_storage_account.primary_access_key
  functions_extension_version = "~4"

  app_settings = count.index==0 ? {
    FUNCTIONS_WORKER_RUNTIME = "python"
    COST = " "
    EMAILS-SECRET = " "
    HTTP_TRIGGER_URL = " "
    NUM_OF_MONTHS = " "
    RECIPIENT_EMAIL	 = " "
    TABLE_DELETED_SUBSCRIPTIONS = " "
    TABLE_EMAILS = " "
    TABLE_SUBSCRIPTIONS_MANAGERS = " "
    TABLE_SUBSCRIPTIONS_TO_DELETE = " "
    SUBSCRIPTION_SECRET = azurerm_key_vault_secret.key_vault_secret.name
    KEYVAULT_URI = data.azurerm_key_vault.key_vault.vault_uri
    https_only                          = true
    DOCKER_REGISTRY_SERVER_URL          = var.DOCKER_REGISTRY_SERVER_URL
    DOCKER_REGISTRY_SERVER_USERNAME     = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.DOCKER_REGISTRY_SERVER_PASSWORD
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  } : count.index==1 ? {
    FUNCTIONS_WORKER_RUNTIME = "python"
    CLOUD_EMAIL = " "
    EMAILS-SECRET = " "
    HTTP_TRIGGER_URL = " "
    HTTP_TRIGGER_URL_SUBSCRIPTION_AUTOMATION = " "
    SUBSCRIPTION_SECRET = azurerm_key_vault_secret.key_vault_secret.name
    KEYVAULT_URI = data.azurerm_key_vault.key_vault.vault_uri
    TABLE_SUBSCRIPTIONS_TO_DELETE = " "
    TAG_NAME = " "
    https_only                          = true
    DOCKER_REGISTRY_SERVER_URL          = var.DOCKER_REGISTRY_SERVER_URL
    DOCKER_REGISTRY_SERVER_USERNAME     = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.DOCKER_REGISTRY_SERVER_PASSWORD
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }: {}
  
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
  count= length(var.function_app_name)
}

resource "azurerm_linux_function_app_slot" "linux_function_app_slot" {
  name                       = "development"
  function_app_id          = azurerm_linux_function_app.function_app[count.index].id
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

  count = length(var.function_app_name)
}

resource "azurerm_storage_table" "example" {
  name                 = var.table_name[count.index]
  storage_account_name = azurerm_storage_account.vnet_storage_account.name
  count = length(var.table_name)

  depends_on = [
    azurerm_storage_account_network_rules.network_rules
 ]

}


data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault_access_policy" "principal" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current_client.tenant_id
  object_id    = azurerm_linux_function_app.function_app[count.index].identity[0].principal_id

  key_permissions = [
    "Get", "List", "Encrypt", "Decrypt"
  ]

  secret_permissions = [
    "Get",
  ]

  count = length(var.function_app_name)
}