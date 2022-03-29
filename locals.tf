locals {
    storage_name = format("storage%s",var.assetname)
    server_name = format("%s%s",var.assetname,var.enviroment)
}
