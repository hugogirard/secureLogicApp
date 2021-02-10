provider "azurerm" { 
  version         = "=2.40.0"

  subscription_id = var.subscriptionId
  client_id       = var.clientId
  client_secret   = var.clientSecret
  tenant_id       = var.tenantID

  features {}
}