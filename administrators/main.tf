resource "azurerm_resource_group" "vnet_resource_group" {
  name     = var.virtual_networks_and_subnets_properties[count.index].resource_group_name
  location = var.location
  count = length(var.virtual_networks_and_subnets_properties)  
}

resource "azurerm_virtual_network" "vnets" {
  for_each = { for vnet in var.virtual_networks_and_subnets_properties : vnet.vnet_name => vnet }

  name                = each.value.vnet_name
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  location            = var.location

  depends_on = [
    azurerm_resource_group.vnet_resource_group
  ]
}


resource "azurerm_subnet" "vnet_subnet" {
  for_each = { for snet in var.virtual_networks_and_subnets_properties : snet.snet_name => snet }

  name                 = each.value.snet_name
  resource_group_name  = azurerm_virtual_network.vnets[each.value.vnet_name].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnets[each.value.vnet_name].name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

locals {
  unique_pairs = toset(flatten([for vnet1 in var.virtual_networks_and_subnets_properties : [for vnet2 in var.virtual_networks_and_subnets_properties : "${vnet1.vnet_name}_${vnet2.vnet_name}" if vnet1.vnet_name != vnet2.vnet_name]]))
}

resource "azurerm_virtual_network_peering" "vnets_peering" {
  for_each = local.unique_pairs
  name                         = each.value
  resource_group_name          = azurerm_virtual_network.vnets[split("_", each.value)[0]].resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnets[split("_", each.value)[0]].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets[split("_", each.value)[1]].id
  allow_virtual_network_access = true
}


resource "azurerm_storage_account" "vnet_storage_account" {
  name                     = var.vnet_storage_account_name
  resource_group_name      = azurerm_resource_group.vnet_resource_group[0].name
  location                 = azurerm_resource_group.vnet_resource_group[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}


data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.location
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

  depends_on = [
    azurerm_storage_account.vnet_storage_account
 ]

}

resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id    = azurerm_storage_account.vnet_storage_account.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet[var.virtual_networks_and_subnets_properties[0].snet_name].id]
  ip_rules                   = ["84.110.136.18"]

  depends_on = [
    azurerm_storage_table.storage_table
 ]

}