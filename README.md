# terraform-for-run
terraform for azure




provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "hub_network" {
  name                = "hub-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "spoke_network1" {
  name                = "spoke-network1"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "spoke_subnet1" {
  name                 = "spoke-subnet1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.spoke_network1.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network1.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network" "spoke_network2" {
  name                = "spoke-network2"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "spoke_subnet2" {
  name                 = "spoke-subnet2"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.spoke_network2.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network2.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.spoke_network1.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.spoke_network2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = true
}



----------------------------------------------------------------------



provider "azurerm" {
  features = {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "hub_network" {
  name                = "hub-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "hub-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

// Spoke Networks
resource "azurerm_virtual_network" "spoke_network1" {
  name                = "spoke-network1"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "spoke_subnet1" {
  name                 = "spoke-subnet1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.spoke_network1.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network1.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network" "spoke_network2" {
  name                = "spoke-network2"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "spoke_subnet2" {
  name                 = "spoke-subnet2"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.spoke_network2.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_network2.id
  allow_virtual_network_access = true
}

// Repeat the above pattern for additional spoke networks

// Peering connections from spoke networks to hub network
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.spoke_network1.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.spoke_network2.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_network.id
  allow_virtual_network_access = true
}

// Repeat the above pattern for additional spoke networks

private endpoint 