resource "azurerm_logic_app_workflow" "logicWorkflowA" {
    name                    = "logicApp-workflow-a"
    location                = var.location
    resource_group_name     = var.rgName
}

# resource "azurerm_logic_app_workflow" "logicWorkflowb" {
#     name                    = "logicApp-workflow-b"
#     location                = var.location
#     resource_group_name     = var.rgName    
# }

resource "azurerm_resource_group_template_deployment" "arm_logic_app_b" {
    name                    = "logicApp-workflow-b-deployment"
    resource_group_name     = var.location
    deployment_mode         = "Incremental"
    template_content        = <<TEMPLATE
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {
        },
        "variables": {
            "workflows_logicApp_workflow_b_name": "logicApp-workflow-b"
        },
        "resources": [
            {
                "type": "Microsoft.Logic/workflows",
                "apiVersion": "2017-07-01",
                "name": "[variables('workflows_logicApp_workflow_b_name')]",
                "location": "${var.location}",
                "properties": {
                    "state": "Enabled",
                    "definition": {
                        "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {},
                        "triggers": {
                            "manual": {
                                "type": "Request",
                                "kind": "Http",
                                "inputs": {
                                    "schema": {}
                                }
                            }
                        },
                        "actions": {
                            "Response": {
                                "runAfter": {},
                                "type": "Response",
                                "kind": "Http",
                                "inputs": {
                                    "body": {
                                        "message": "Hello from Logic App B"
                                    },
                                    "statusCode": 200
                                }
                            }
                        },
                        "outputs": {}
                    },
                    "parameters": {}
                }
            }
        ]
    }
    TEMPLATE
}

resource "azurerm_logic_app_workflow" "logicWorkflowc" {
    name                    = "logicApp-workflow-c"
    location                = var.location
    resource_group_name     = var.rgName
}