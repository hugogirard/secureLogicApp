resource "azurerm_resource_group" "rg" {
    name            = var.resourceGroupName
    location        = var.location
}

module "apim" {
  source            = "./modules/apim"

  apimName          = var.apimName
  location          = var.location
  rgName            = azurerm_resource_group.rg.name
  publisherName     = var.publisherName
  publisherEmail    = var.publisherEmail
}

module "logicApp" {
  source            = "./modules/logicapp"
  location          = var.location
  rgName            = azurerm_resource_group.rg.name
}