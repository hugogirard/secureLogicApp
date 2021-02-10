resource "azurerm_logic_app_workflow" "logicWorkflowA" {
    name                    = "logicApp-workflow-a"
    location                = var.location
    resource_group_name     = var.rgName
}

resource "azurerm_logic_app_workflow" "logicWorkflowb" {
    name                    = "logicApp-workflow-b"
    location                = var.location
    resource_group_name     = var.rgName
    
}

resource "azurerm_logic_app_workflow" "logicWorkflowc" {
    name                    = "logicApp-workflow-c"
    location                = var.location
    resource_group_name     = var.rgName
}