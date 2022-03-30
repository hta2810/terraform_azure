variable "substitutionsid" {
    type = string
    description = "Subscription ID"
}
variable "resource_group_name" {
    type = string
}
variable "assetname" {
    type = string
}

variable "enviroment" {
    type = string         
}   

variable "location" {
  type = string
}

variable "sku" {
  type = map(string)
  default = {
    "tier" = "Basic"
    "size" = "B1"
  }
}
