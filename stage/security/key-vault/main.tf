terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }

    backend "azurerm" {
      resource_group_name  = "v1vhm-rg-tfstate-prod-weu-001"
      storage_account_name = "v1vhmsttfstateprodweu001"
      container_name       = "tfstate"
      key                  = "stage/security/key-vault/terraform.tfstate"
      use_azuread_auth     = true
    }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when t$he User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    
  }
}

data "azurerm_client_config" "current" {

}

# Create a resource group
resource "azurerm_resource_group" "credstore" {
  name     = "v1vhm-credstore-prod-weu-001"
  location = "West Europe"
}

# Create the key vault
resource "azurerm_key_vault" "credstore" {
  name                      = "v1vhm-kv-credstore-stage"
  location                  = azurerm_resource_group.credstore.location
  resource_group_name       = azurerm_resource_group.credstore.name
  sku_name                  = "standard"
  tenant_id                 = azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  purge_protection_enabled  = false

  
}

resource "azurerm_role_assignment" "kvaccess" {
  
}