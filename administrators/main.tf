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

  # network_rules {
  #   default_action             = "Deny"
  #   virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
  # }
}

data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = "West Europe"
  resource_group_name         = azurerm_storage_account.vnet_storage_account.resource_group_name
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
  value        = azurerm_storage_account.vnet_storage_account.primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_storage_table" "storage_table" {
  name                 = var.table_name
  storage_account_name = azurerm_storage_account.vnet_storage_account.name
}
