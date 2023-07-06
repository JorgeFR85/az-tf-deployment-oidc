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
variable "lb_sku" {}

# Variables lb-backend-address-pool

variable "name_BackEndAddressPool" {}

# Variables lb-nat-rule


variable "backend_port" {}
variable "frontend_ip_configuration_name" {}
variable "name_lb_nat_rule" {}
variable "protocol_lb_nat_rule" {}
variable "frontend_port" {}

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
  lb_sku                                 = var.lb_sku
  location                               = var.location

  tags = var.tags
}

module "mylb-backend-address-pool" {
  source                                 = "git@github.com:ragalgut/az-tf-module-lb-backend-address-pool.git"

  loadbalancer_id                    = module.mylb.azurerm_lb_id
  name_BackEndAddressPool            = var.name_BackEndAddressPool

}

module "mylb-nat-rule" {
  source                                 = "git@github.com:ragalgut/az-tf-module-lb-nat-rule.git"

  backend_port                      = var.backend_port
  frontend_ip_configuration_name    = var.frontend_ip_configuration_name
  loadbalancer_id                   = module.mylb.azurerm_lb_id 
  name_lb_nat_rule                  = var.name_lb_nat_rule
  protocol_lb_nat_rule              = var.protocol_lb_nat_rule
  resource_group_name               = var.resource_group_name
  frontend_port                     = var.frontend_port

}

module "mylb-probe" {
  source                                 = "git@github.com:ragalgut/az-tf-module-lb-probe.git"

  loadbalancer_id                     = module.mylb.azurerm_lb_id 
  name_probe                          = var.name_probe
  port_probe                          = var.port_probe
  lb_probe_interval                   = var.lb_probe_interval
  lb_probe_unhealthy_threshold        = var.lb_probe_unhealthy_threshold
  protocol_probe                      = var.protocol_probe
  request_path                        = var.request_path

}

module "mylb-rule" {
  source                                 = "git@github.com:ragalgut/az-tf-module-lb-rule.git"

  backend_port_lb_rule                = var.backend_port_lb_rule
  frontend_name_lb_rule               = var.frontend_name_lb_rule
  frontend_port_lb_rule               = var.frontend_port_lb_rule 
  loadbalancer_id                     = module.mylb.azurerm_lb_id 
  name_lb_rule                        = var.name_lb_rule
  protocol_lb_rule                    = var.protocol_lb_rule
  backend_address_pool_ids            = module.mylb-backend-address-pool.id
  disable_outbound_snat               = var.disable_outbound_snat 
  lb_floating_ip_enabled              = var.lb_floating_ip_enabled
  idle_timeout_in_minutes             = var.idle_timeout_in_minutes
  probe_id                            = module.mylb-probe.id

}