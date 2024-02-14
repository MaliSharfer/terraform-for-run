terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate-modules-try"
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

module administrator {
  source = "../administrator/"
}

module emails{
    source = "../emails/"
    key_vault_name = module.administrators.key_vault_name
    key_vault_resource_group_name = module.administrators.key_vault_resource_group_name
    DOCKER_REGISTRY_SERVER_URL = var.DOCKER_REGISTRY_SERVER_URL
    DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD

    depends_on = [
      module.administrators
    ]
}

module subscriptions {
    source = "../subscriptions-automation/"
    key_vault_name = module.administrators.key_vault_name
    key_vault_resource_group_name = module.administrators.key_vault_resource_group_name
    DOCKER_REGISTRY_SERVER_URL = var.DOCKER_REGISTRY_SERVER_URL
    DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD
    depends_on = [
      module.emails
    ]
}

module storages{
  source = "../storages/"
  key_vault_name = module.administrators.key_vault_name
  key_vault_resource_group_name = module.administrators.key_vault_resource_group_name
  key_vault_secret_excel_name = module.administrators.secret_administrators_name
  DOCKER_REGISTRY_SERVER_URL = var.DOCKER_REGISTRY_SERVER_URL
  DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
  DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD

  depends_on = [
    module.emails
  ]
}
