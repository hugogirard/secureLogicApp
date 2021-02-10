resource "azuread_application" "workflow_a" {
    display_name = "logic-app-workflow-a"    
    type         = "webapp/api"
}

resource "azuread_application" "workflow_b" {
    display_name = "logic-app-workflow-b"    
    type         = "webapp/api"

    app_role {
        allowed_member_types = [            
            "Application",
        ]

        description  = "Allow to trigger the http logic app"
        display_name = "Allow.Http.Trigger"
        is_enabled   = true
        value        = "Allow.Http.Trigger"
    }    
}