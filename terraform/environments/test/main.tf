provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {}
}
# This is where the terraform state is held in the storage account
terraform {
  backend "azurerm" {
    subscription_id      = "87374ef2-5c69-4884-abed-6e7bb3294548"
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate16018"
    container_name       = "tfstate"
    key                  = "terraform.state"
  }
}

# start the module building
module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.prefix}-rg" # personally this is how I like to have my stuff with pre-defined tags on the end for consistentcy
  location             = var.location
}
module "app_service" {
  source                  = "../../modules/appservice"
  prefix                  = var.prefix
  resource_group          = module.resource_group.resource_group_name
  location                = var.location
}
module "publicip" {
  source                  = "../../modules/publicip"
  prefix                  = var.prefix
  resource_group          = module.resource_group.resource_group_name
  location                = var.location
}
module "virtual_network" {
  source                 = "../../modules/virtualnetwork"
  prefix                 = var.prefix
  resource_group         = module.resource_group.resource_group_name # Use the name that was output by the resource group module
  location               = var.location
}
module "security_group" {
  source                  = "../../modules/securitygroup"
  prefix                  = var.prefix
  resource_group          = module.resource_group.resource_group_name
  location                = var.location
  subnet_id               = module.virtual_network.subnet_id
  subnet_address_prefixes = module.virtual_network.subnet_address_prefixes
}

module "virtual_machine" {
  source                  = "../../modules/vm"
  prefix                  = var.prefix
  resource_group          = module.resource_group.resource_group_name
  location                = var.location
  public_ip_address_id    = module.publicip.public_ip_address_id
  subnet_id               = module.virtual_network.subnet_id
  admin_username          = var.admin_username
  public_key              = var.public_key
}