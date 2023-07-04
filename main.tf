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
variable "frontend_name" {}
variable "frontend_subnet_id" {}
variable "frontend_private_ip_address_allocation" {}
variable "frontend_private_ip_address" {}
variable "lb_sku" {}
variable "name_lb" {}
variable "remote_port" {}
variable "lb_port" {}
variable "lb_probe" {}


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

  resource_group_name                    = var.resource_group_name
  type                                   = var.type
  frontend_name                          = var.frontend_name
  frontend_subnet_id                     = var.frontend_subnet_id
  frontend_private_ip_address_allocation = var.frontend_private_ip_address_allocation
  frontend_private_ip_address            = var.frontend_private_ip_address
  lb_sku                                 = var.lb_sku
  location                               = var.location
  name_lb                                = var.name_lb

  remote_port = var.remote_port

  lb_port = var.lb_port

  lb_probe = var.lb_probe

  tags = var.tags

  #depends_on = [azurerm_resource_group.test]
}