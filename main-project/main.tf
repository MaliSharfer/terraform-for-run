terraform {
  # backend "azurerm" {
  #   resource_group_name  = "functionyvwow"
  #   storage_account_name = "functionyvwowdcbbfc"
  #   container_name       = "terraformstate-modules"
  #   key                  = "terraform.tfstate"
  # }
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
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

module "administrators" {
  source = "../administrators/"
}

module "emails" {
  source = "../emails/"

  rg_name                       = module.administrators.resource_group_emails
  rg_location                   = module.administrators.location
  vnet_subnet_id                = module.administrators.subnet_id_emails
  key_vault_name                = module.administrators.key_vault_name
  key_vault_resource_group_name = module.administrators.key_vault_resource_group_name

  DOCKER_REGISTRY_SERVER_URL      = var.DOCKER_REGISTRY_SERVER_URL
  DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
  DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD

  depends_on = [
    module.administrators
  ]
}

module "subscriptions" {
  source                        = "../subscriptions-automation/"
  rg_name                       = module.administrators.resource_group_subscription_automation
  rg_location                   = module.administrators.location
  vnet_subnet_id                = module.administrators.subnet_id_subscription_automation
  key_vault_name                = module.administrators.key_vault_name
  key_vault_resource_group_name = module.administrators.key_vault_resource_group_name

  DOCKER_REGISTRY_SERVER_URL      = var.DOCKER_REGISTRY_SERVER_URL
  DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
  DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD
  depends_on = [
    module.emails
  ]
}

module "storages" {
  source = "../storages/"

  rg_name                       = module.administrators.resource_group_storages_automation
  rg_location                   = module.administrators.location
  vnet_subnet_id                = module.administrators.subnet_id_storages_automation
  key_vault_name                = module.administrators.key_vault_name
  key_vault_resource_group_name = module.administrators.key_vault_resource_group_name
  key_vault_secret_excel_name   = module.administrators.secret_administrators_name

  DOCKER_REGISTRY_SERVER_URL      = var.DOCKER_REGISTRY_SERVER_URL
  DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
  DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD
  depends_on = [
    module.emails
  ]
}