# resource group
resource_group_name = "rg-test00"
location = "West Europe"

# lb

type = "private"
name_lb = "testlb"
frontend_name = "testnamefront"
frontend_subnet_id = "/subscriptions/4c595a39-ef54-4e5c-af06-8ffd1963ac5e/resourceGroups/labs/providers/Microsoft.Network/virtualNetworks/vnet-test/subnets/default"
frontend_private_ip_address_allocation = "static"
frontend_private_ip_address = "10.0.0.7"
lb_sku = "Standard"
sku_tier = ""
edge_zone = ""

remote_port = {
  ssh = ["Tcp", "22"]
}

lb_port = {
  http  = ["80", "Tcp", "80"]
   https = ["443", "Tcp", "443"]
}

lb_probe = {
  http  = ["Tcp", "80", ""]
  http2 = ["Http", "1443", "/"]
}


tags = {
  "test5" = "test6"
}
