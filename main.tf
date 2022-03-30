module "app_service" {
    source = "./modules/app_service/"
    resource_group_name = var.resource_group_name
    location = var.location
    sku = {
        "tier" = "Basic"
        "size" = "B1"
    }
}




