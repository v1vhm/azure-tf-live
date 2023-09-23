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
      key                  = "stage/data-stores/mysql/terraform.tfstate"
      use_azuread_auth     = true
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when t$he User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    
  }
}

# Create a resource group
resource "azurerm_resource_group" "data" {
  name     = "v1vhm-database-stage-weu-001"
  location = "West Europe"
}

# Create a mysql database
resource "azurerm_mysql_flexible_server" "example" {
  name                   = "v1vhm-datastore-stage-weu-001"
  location               = azurerm_resource_group.data.location
  resource_group_name    = azurerm_resource_group.data.name
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1s"
}

resource "azurerm_mysql_flexible_database" "example" {
  name                = "terraform-up-and-running"
  resource_group_name = azurerm_resource_group.data.name
  server_name         = azurerm_mysql_flexible_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}