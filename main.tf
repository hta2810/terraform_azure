resource "azurerm_resource_group" "rg" {
    name = local.resource_name
    location = var.location
}

module "app_service" {
    source = "./modules/app_service/"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = {
        "tier" = "Basic"
        "size" = "B1"
    }
}




