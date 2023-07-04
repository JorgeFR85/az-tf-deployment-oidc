# Provider
provider "azurerm" {
  features {}
}

provider "azuread" {
  use_oidc = true
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.53.0"
    }
    
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }
 
  }
  required_version = "~> 1.5.1"
  

  backend "azurerm" {
    resource_group_name = "lab-rg"            # Nombre del grupo de recursos donde se encuentra la cuenta de almacenamiento
    storage_account_name = "labaztfbackend"  # Nombre de la cuenta de almacenamiento donde se va almacenar el fichero de estado
    container_name = "tbackend"                   # Nombre del container donde se va almacenar el fichero de estado
    key = "terraform.tfstate"                     # Nombre del fichero de estado. El nombre estándar es terraform.tfstate
  }
  
}

# Variables del modulo RG
variable "resource_group_name" {}
variable "location" {}

# Variables lb

variable "type" {}
variable "name_lb" {}
variable "frontend_name" {}
variable "frontend_subnet_id" {}
variable "frontend_private_ip_address_allocation" {}
variable "frontend_private_ip_address" {}
variable "edge_zone" {}
variable "lb_sku" {}
variable "sku_tier" {}



# Variables tags
variable "tags" {}

# Módulo resource-group
module "resource-group" {

  source = "git@github.com:ragalgut/az-tf-module-resource-group.git"

  resource_group_name = var.resource_group_name
  location = var.location

  tags = var.tags
}


module "mylb" {
  source                                 = "git@github.com:ragalgut/az-tf-module-load-balancer.git"

  type                                   = var.type
  name_lb                                = var.name_lb
  resource_group_name                    = var.resource_group_name
  frontend_name                          = var.frontend_name
  frontend_subnet_id                     = var.frontend_subnet_id
  frontend_private_ip_address_allocation = var.frontend_private_ip_address_allocation
  frontend_private_ip_address            = var.frontend_private_ip_address
  edge_zone                              = var.edge_zone
  lb_sku                                 = var.lb_sku
  sku_tier                               = var.lb_sku_tier
  location                               = var.location

  tags = var.tags
}