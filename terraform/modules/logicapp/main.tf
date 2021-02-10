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

resource "azurerm_template_deployment" "arm_logic_app_b" {
    name                    = azurerm_logic_app_workflow.logicWorkflowb.name
    resource_group_name     = azurerm_logic_app_workflow.logicWorkflowb.location
    template_body           = file("arm/workflowb.json")
    deployment_mode         = "Incremental"
}

resource "azurerm_logic_app_workflow" "logicWorkflowc" {
    name                    = "logicApp-workflow-c"
    location                = var.location
    resource_group_name     = var.rgName
}