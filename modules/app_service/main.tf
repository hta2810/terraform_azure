resource "azurerm_app_service_plan" "asp" {
    name = "team2-app-service-plan-01"
    resource_group_name = var.resource_group_name
    location = var.location
    sku {
        tier = var.sku["tier"]
        size = var.sku["size"]
    }
}

resource "azurerm_app_service" "as" {
    name = "team2-app-service-01"
    location = var.location
    resource_group_name = var.resource_group_name
    app_service_plan_id = azurerm_app_service_plan.asp.id
    source_control {
        repo_url = "https://github.com/Wordpress/Wordpress"
        branch = "master"
        manual_integration = true
        use_mercurial      = false
    }
}
