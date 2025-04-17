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

# DB Subnet
resource "azurerm_subnet" "login-db-sn" {
  name                 = "login-db-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Web Public IP
resource "azurerm_public_ip" "login-web-pip" {
  name                = "login-web-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
  location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "web"
  }
}

# API Public IP
resource "azurerm_public_ip" "login-api-pip" {
  name                = "login-api-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
  location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "api"
  }
}

# Web NSG
resource "azurerm_network_security_group" "login-web-nsg" {
  name                = "login-web-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

# Web NSG - SSH rule
resource "azurerm_network_security_rule" "login-web-nsg-ssh" {
  name                        = "login-web-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-web-nsg.name
}

# Web NSG - HTTP rule
resource "azurerm_network_security_rule" "login-web-nsg-http" {
  name                        = "login-web-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.login-rg.name
  network_security_group_name = azurerm_network_security_group.login-web-nsg.name
}