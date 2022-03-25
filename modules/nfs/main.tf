resource "azurerm_storage_account" "example" {
    name = "${local.storage_name}01"
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    account_kind = "FileStorage"
    account_tier = "Premium"
    account_replication_type = "LRS"
}

resource "azurerm_storage_share" "example" {
    name = "${local.storage_name}nfs"
    storage_account_name = azurerm_storage_account.example.name
    quota = 50
    enabled_protocol = "NFS"
}
