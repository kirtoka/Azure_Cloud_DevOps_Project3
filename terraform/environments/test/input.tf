# Azure Secrets
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "public_key" {}
variable "admin_username" {}

variable "prefix" {
  description = "Prefix"
  default     = "udacity-project3"
  type        = string
}

# Resource Vars
variable "location" {
  description = "Azure Region Location which call resources will reside"
  default     = "eastus"
  type        = string
}

