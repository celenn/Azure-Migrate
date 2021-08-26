terraform {
   
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.73.0"
    }
  }
}

provider "azurerm" {
    features {}

}

resource "azurerm_resource_group" "resource_group" {
  name     = "celen-bupa-migrate-rg"
  location = "uksouth"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "bupa-migrate-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "migrate_subnet" {
  name                 = "bupa-migrate-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_database_migration_service" "dbms" {
  name                = "database_migration_service-dbms"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id   = azurerm_subnet.migrate_subnet.id
  sku_name            = "Standard_1vCores"
}

resource "azurerm_database_migration_project" "adbmp" {
  name                = "bupa-dbms-project"
  service_name        = azurerm_database_migration_service.dbms.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  source_platform     = "SQL"
  target_platform     = "SQLDB"
}