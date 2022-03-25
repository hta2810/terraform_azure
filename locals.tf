locals {
    resource_name = format("%s-%s-%s", var.assetname, var.enviroment, var.location)
    storage_name = format("storage%s",var.assetname)
    server_name = format("%s%s",var.assetname,var.enviroment)
}