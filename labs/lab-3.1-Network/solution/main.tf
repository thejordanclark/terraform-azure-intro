terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.86"
    }
  }
  cloud {
    organization = "ABC-Labs"
    workspaces {
      name = "labs-XX"
    }
  }
  required_version = ">= 1.3.0"
}

provider "random" {
}

provider "azurerm" {
  features {}
  # Set the following flag to avoid an Azure subscription configuration error
  skip_provider_registration = true
}

resource "azurerm_resource_group" "lab" {
  name     = "aztf-labs-rg"
  location = "eastus2"
  tags     = {
    Environment = "Lab"
    Project     = "AZTF Training"
  }
}

resource "azurerm_virtual_network" "lab" {
  name                = "aztf-labs-vnet"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = ["10.0.0.0/16"]
  tags                = {
    Environment = "Lab"
    Project     = "AZTF Training"
  }
}

resource "azurerm_subnet" "lab-public" {
  name                 = "aztf-labs-subnet-public"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "lab-private" {
  name                 = "aztf-labs-subnet-private"
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "lab-public" {
  name                = "aztf-labs-public-sg"
  location            = "eastus2"
  resource_group_name = azurerm_resource_group.lab.name
}

resource "azurerm_subnet_network_security_group_association" "lab-public" {
  subnet_id                 = azurerm_subnet.lab-public.id
  network_security_group_id = azurerm_network_security_group.lab-public.id
}
