

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when t$he User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {

  }
}

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
    key                  = "prod/services/webserver-cluster/terraform.tfstate"
    use_azuread_auth     = true
  }
}

module "webserver_cluster" {
  source                          = "../../../../azure-tf-modules/services/webserver-cluster"
  cluster_name                    = "webserver"
  environment                     = "prod"
  db_remote_state_key             = "prod/data-stores/mysql/terraform.tfstate"
  db_remote_state_resource_group  = "v1vhm-rg-tfstate-prod-weu-001"
  db_remote_state_storage_account = "v1vhmsttfstateprodweu001"
  enable_autoscaling              = true
  server_text                     = "Hello, production world!"
  app_version                     = "003"


  custom_tags = {
    Owner     = "team-foo"
    ManagedBy = "terraform"
  }
}