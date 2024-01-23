terraform {
  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "myfirsttrail"
    container_name       = "terraformstate-networkingexample"
    key                  = "terraform.tfstate"
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

resource "azurerm_resource_group" "example" {
  name     = "cloude-check"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "cloud-network"
  address_space       = ["172.16.0.0/12"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_virtual_wan" "example" {
  name                = "cloud-vwan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_virtual_hub" "example" {
  name                = "cloud-hub"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  virtual_wan_id      = azurerm_virtual_wan.example.id
  address_prefix      = "10.0.1.0/24"
}

resource "azurerm_virtual_hub_connection" "example" {
  name                      = "example-vhub"
  virtual_hub_id            = azurerm_virtual_hub.example.id
  remote_virtual_network_id = azurerm_virtual_network.example.id
}





# resource "azurerm_resource_group" "example" {
#   name     =  var.rg_name[count.index]
#   location = "West Europe"
#   count = length(var.rg_name)
# }

# resource "azurerm_virtual_network" "example" {
#   name                = var.nt_name[count.index]
#   address_space       = ["172.16.0.0/12"]
#   location            = azurerm_resource_group.example[count.index].location
#   resource_group_name = azurerm_resource_group.example[count.index].name

#   count = length(var.nt_name)
# }

# resource "azurerm_virtual_wan" "example" {
#   name                = "mal-vwan"
#   resource_group_name = azurerm_resource_group.example[count.index].name
#   location            = azurerm_resource_group.example[count.index].location
#   count = length(var.rg_name)
# }

# resource "azurerm_virtual_hub" "example" {
#   name                = "mal-hub"
#   resource_group_name = azurerm_resource_group.example[count.index].name
#   location            = azurerm_resource_group.example[count.index].location
#   virtual_wan_id      = azurerm_virtual_wan.example.id
#   address_prefix      = "10.0.1.0/24"

#   count = length(var.rg_name)
# }

# resource "azurerm_virtual_hub_connection" "example" {
#   name                      = "mal-vhub"
#   virtual_hub_id            = azurerm_virtual_hub.example.id
#   remote_virtual_network_id = azurerm_virtual_network.example.id
# }