terraform {
required_providers {
azurerm = {
source                              = "hashicorp/azurerm"
version                             = "~> 2.65"
 }
}
required_version = ">= 1.1.0"
}

  terraform {
    backend "azurerm" {
     resource_group_name  = "RG_team2_case3_v2_20220329"
     storage_account_name = "lbnteam2storage"
     container_name       = "lbnteam2"
     key                  = "terraform.tfstate"
    }
  }

provider "azurerm" {
skip_provider_registration          = "true"
features {}
subscription_id                     = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
tenant_id                           = "7d37f2bd-a1dc-4e2c-aaa3-c758dc77fff7"
}

 resource "azurerm_virtual_network" "virtua2network" {
 name                               = "team2network"
 location                           = "East Asia"
 resource_group_name                = "RG_team2_case3_v2_20220329"
 address_space                      = ["10.0.0.0/16"]
 }

resource "azurerm_storage_account" "example" {
  name                              = "lbnteam2storage"
  resource_group_name               = "RG_team2_case3_v2_20220329"
  location                          = "East Asia"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"

  tags = {
    environment                     = "staging"
  }
}


resource "azurerm_storage_container" "example" {
  name                              = "lbnteam2"
  storage_account_name              = azurerm_storage_account.example.name
  container_access_type             = "private"
}


resource "azurerm_app_service_plan" "app-plan" {
name                                = "lbnteam2serviceplan"
location                            = "East Asia"
resource_group_name                 = "RG_team2_case3_v2_20220329"


sku {
tier                                = "Standard"
size                                = "F1"
}
}


resource "azurerm_app_service" "webapp" {
name                                = "LBN-team2-wep-app"
location                            = "East Asia"
resource_group_name                 = "RG_team2_case3_v2_20220329"
app_service_plan_id                 = azurerm_app_service_plan.app-plan.id


app_settings = {
"SOME_KEY"                          = "some-value"
}
connection_string {
name                                = "Database"
type                                = "SQLServer"
value                               = "Server=some-server.mydomain.com;Integrated Security=SSPI"
}
source_control {

     repo_url                       = "https://github.com/WordPress/WordPress"
     branch                         = "master"
     use_mercurial                  = false
     manual_integration             = true
 }
}


resource "azurerm_mysql_server" "mysql-server" {
name                                = "lbnteam2mysqlserver"
location                            = "East Asia"
resource_group_name                 = "RG_team2_case3_v2_20220329"



administrator_login                 = "team2lbn"
administrator_login_password        = "P@ssw0rd1234"



 sku_name                           = "B_Gen5_2"
 storage_mb                         = 5120
 version                            = "5.7"




 auto_grow_enabled                  = true
 public_network_access_enabled      = true
 ssl_enforcement_enabled            = false
 ssl_minimal_tls_version_enforced   = "TLSEnforcementDisabled"
}


resource "azurerm_mysql_database" "app-database" {
name                                = "lbnteam2appdatabase"
resource_group_name                 = "RG_team2_case3_v2_20220329"
server_name                         = azurerm_mysql_server.mysql-server.name
 charset                            = "utf8"
 collation                          = "utf8_unicode_ci"
}


 resource "azurerm_monitor_autoscale_setting" "example" {
   name                              = "myAutoscaleSetting"
   enabled                           = true
   resource_group_name               = "RG_team2_case3_v2_20220329"
   location                          = "East Asia"
   target_resource_id                = azurerm_app_service_plan.app-plan.id

   profile {
     name    = "lbnteam-1"

     capacity {
       default = 1
       minimum = 1
       maximum = 4
     }

     rule {
       metric_trigger {
         metric_name                 = "CpuPercentage"
         metric_resource_id          = azurerm_app_service_plan.app-plan.id
         time_grain                  = "PT1M"
         statistic                   = "Average"
         time_window                 = "PT5M"
         time_aggregation            = "Average"
         operator                    = "GreaterThan"
         threshold                   = 70
       }


       scale_action {
         direction                   = "Increase"
         type                        = "ChangeCount"
         value                       = "1"
         cooldown                    = "PT1M"
       }
     }

     rule {
       metric_trigger {
         metric_name                 = "CpuPercentage"
         metric_resource_id          = azurerm_app_service_plan.app-plan.id
         time_grain                  = "PT1M"
         statistic                   = "Average"
         time_window                 = "PT5M"
         time_aggregation            = "Average"
         operator                    = "LessThan"
         threshold                   = 30
       }

       scale_action {
         direction                   = "Decrease"
         type                        = "ChangeCount"
         value                       = "1"
         cooldown                    = "PT1M"
       }
     }
  }
}
