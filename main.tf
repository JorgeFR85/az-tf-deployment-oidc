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

# Variables tags
variable "tags" {}

# Módulo resource-group
module "resource-group" {

  source = "git@github.com:ragalgut/az-tf-module-resource-group.git"

  resource_group_name = var.resource_group_name
  location = var.location
  tags = var.tags
}
