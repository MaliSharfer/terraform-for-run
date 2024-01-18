# terraform {
#   backend "azurerm" {
#     resource_group_name      = "NetworkWatcherRG"
#     storage_account_name     = "myfirsttrail"
#     container_name           = "terraformstate-networking"
#     key                      = "terraform.tfstate"
#   }
# }

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
  name                     = "stwow"
  resource_group_name      = azurerm_resource_group.vnet_resource_group.name
  location                 = azurerm_resource_group.vnet_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
  }
}

resource "azurerm_storage_table" "storage_table" {
  name                 = var.table_name
  storage_account_name = azurerm_storage_account.vnet_storage_account.name
}
