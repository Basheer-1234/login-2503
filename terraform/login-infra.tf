# Azure Resource Group
resource "azurerm_resource_group" "login-rg" {
  name     = "login-rg"
  location = "East US"
}

# VNET
resource "azurerm_virtual_network" "login-vnet" {
  name                = "login-vnet"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
  address_space       = ["10.0.0.0/16"]
}

# Web Subnet
resource "azurerm_subnet" "login-web-sn" {
  name                 = "login-web-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# API Subnet
resource "azurerm_subnet" "login-api-sn" {
  name                 = "login-api-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}