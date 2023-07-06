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

tags = {
  "test5" = "test6"
}

# Variables lb-backend-address-pool
name_BackEndAddressPool = "testbackendaddress"

# Variables lb-nat-rule

name_lb_nat_rule = "testnatrule"
protocol_lb_nat_rule = "Tcp"
frontend_port = "3389"
backend_port = "3389"
frontend_ip_configuration_name = "testnamefront"

# Variables mylb-probe

name_probe = "ssh-running-probe"
port_probe = "22"
lb_probe_interval = "5"
lb_probe_unhealthy_threshold = "1"
protocol_probe = "https"
request_path = "/"


# Variables mylb-rule

backend_port_lb_rule = "3389"
frontend_name_lb_rule = "testnamefront"
frontend_port_lb_rule = "3389" 
name_lb_rule = "testnamelbrule"
protocol_lb_rule = "Tcp"
disable_outbound_snat = "false" 
lb_floating_ip_enabled = "false"
idle_timeout_in_minutes = "4"