resource "azurerm_resource_group" "this_rg" {
  name     = local.vnet_rg_name
  location = var.location
  tags = merge(
    local.common_tags,
    {
      name = local.vnet_rg_name
    },
    var.vnet_rg_tags
  )
}

# Random String for V-net name
resource "random_string" "vnet_random" {
  length  = 6
  special = false
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "2.4.0"
  # This check is litterally a workaround for the stupid data resource in that Azure VNET module to check whether the specified resource group exists or not
  # check main.tf in this Azure/vnet/azurerm module
  count = var.create_vnet ? 1 : 0

  depends_on                                            = [azurerm_resource_group.this_rg]
  resource_group_name                                   = azurerm_resource_group.this_rg.name
  vnet_name                                             = "${var.vnet_name_prefix}-${random_string.vnet_random.result}"
  address_space                                         = var.vnet_address_space
  subnet_prefixes                                       = var.subnet_prefixes
  dns_servers                                           = var.dns_servers
  subnet_names                                          = var.subnet_names
  subnet_service_endpoints                              = var.subnet_service_endpoints
  subnet_enforce_private_link_endpoint_network_policies = var.subnet_enforce_private_link_endpoint_network_policies
  tags = merge(
    local.common_tags,
    {
      name = var.vnet_name_prefix
    },
    var.vnet_tags
  )
}

module "vnet_peering_with_hub" {
  source  = "claranet/vnet-peering/azurerm"
  version = "4.0.0"
  count   = var.peer_with_hub ? 1 : 0

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm.hub
  }

  vnet_src_id                       = module.vnet[0].vnet_id
  vnet_dest_id                      = var.hub_vnet_id
  use_remote_src_gateway            = true
  allow_forwarded_src_traffic       = true
  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true
  allow_forwarded_dest_traffic      = true
  allow_gateway_dest_transit        = true
}

module "vnet_peering_with_commvault_vnet" {
  source  = "claranet/vnet-peering/azurerm"
  version = "4.0.0"
  count   = var.peer_with_commvault_vnet ? 1 : 0

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm.management
  }

  vnet_src_id                       = module.vnet[0].vnet_id
  vnet_dest_id                      = var.commvault_vnet_id
  use_remote_src_gateway            = false
  allow_forwarded_src_traffic       = true
  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true
  allow_forwarded_dest_traffic      = true
  allow_gateway_dest_transit        = false
}


resource "random_string" "this_rt" {
  length  = 6
  special = false
}

resource "azurerm_route_table" "this_rt" {
  for_each                      = local.route_tables
  name                          = "${each.key}-${random_string.this_rt.result}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.this_rg.name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = each.value["route"]
    content {
      name                   = route.value["name"]
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = merge(
    local.common_tags,
    each.value["tags"]
  )
}

resource "azurerm_subnet_route_table_association" "vm_subnet" {
  for_each = { for k, v in var.route_table_association :
    index(var.subnet_names, k) => v
  }

  subnet_id      = module.vnet[0].vnet_subnets[each.key]
  route_table_id = azurerm_route_table.this_rt[each.value].id
}
