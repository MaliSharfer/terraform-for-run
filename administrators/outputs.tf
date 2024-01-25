output location {
  value       = var.location
}

output resource_group_emails {
  value       = azurerm_resource_group.vnet_resource_group[1].name
}

output resource_group_subscription_automation {
  value       = azurerm_resource_group.vnet_resource_group[2].name
}

output resource_group_storages_automation {
  value       = azurerm_resource_group.vnet_resource_group[3].name
}


output subnet_id_emails {
  value       = azurerm_subnet.vnet_subnet[var.virtual_networks_and_subnets_properties[1]].id
}

output subnet_id_subscription_automation {
  value       = azurerm_subnet.vnet_subnet[var.virtual_networks_and_subnets_properties[2]].id
}

output subnet_id_storages_automation {
  value       = azurerm_subnet.vnet_subnet[var.virtual_networks_and_subnets_properties[3]].id
}

output key_vault_name {
  value       = azurerm_key_vault.key_vault.name
}

output key_vault_resource_group_name {
  value       = azurerm_key_vault.key_vault.resource_group_name 
}

output secret_administrators_name {
  value       = azurerm_key_vault_secret.key_vault_secret.name
}


