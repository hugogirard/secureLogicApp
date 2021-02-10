resource "random_id" "apim_name_suffix" {
    byte_length = 8
}

resource "azurerm_api_management" "apim" {
    name                    = "${var.apimName}-${random_id.apim_name_suffix.dec}"
    location                = var.location
    resource_group_name     = var.rgName
    publisher_name          = var.publisherName
    publisher_email         = var.publisherEmail

    sku_name = "Developer_1"
}