module "test" {
  source                   = "../../"
  create_vnet              = true
  peer_with_hub            = true
  peer_with_commvault_vnet = true
  environment              = "prod"
  vnet_name_prefix         = "prod-test-vnet"
  vnet_address_space       = ["10.18.0.0/21"]
  subnet_prefixes          = ["10.18.1.0/24", "10.18.2.0/24"]
  subnet_names             = ["subnet-1", "subnet-2"]

  route_tables = {
    "z-nonprod-apim-rt" = {
      disable_bgp_route_propagation = true,
      ignore_route_changes          = false,
      route = [
        {
          name           = "blackhole_fw_mgmt"
          address_prefix = "10.18.2.0/24"
          next_hop_type  = "None"
        },
        {
          name           = "blackhole_fw_public"
          address_prefix = "10.18.3.0/24"
          next_hop_type  = "None"
        },
        {
          name                   = "internal_2_LB_obewfw"
          address_prefix         = "10.0.0.0/8"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.18.4.21"
        }
      ],
      tags = {
        name = "z-nonprod-apim-rt"
      }
    },
    "z-dev-aks-rt" = {
      disable_bgp_route_propagation = true,
      ignore_route_changes          = false,
      route = [
        {
          name           = "blackhole_fw_mgmt"
          address_prefix = "10.18.2.0/24"
          next_hop_type  = "None"
        },
        {
          name           = "blackhole_fw_public"
          address_prefix = "10.18.3.0/24"
          next_hop_type  = "None"
        },
        {
          name                   = "default_2_LB_obewfw"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.18.4.21"
        }
      ],
      tags = {
        name = "z-dev-aks-rt"
      }
    }
  }

  route_table_association = {
    "subnet-1" = "z-prod-to_obeafw-rt"
    "subnet-2" = "z-dev-aks-rt"
  }
}
