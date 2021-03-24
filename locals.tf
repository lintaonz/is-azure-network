locals {
  default_common_tags = {
    cost_center        = ""
    created_using      = "Terraform"
    environment        = var.environment
    hours_of_operation = ""
    owner              = ""
    version            = ""
    git_repo           = "https://bitbucket.org/twgnz/is-azure-landing-zone"
    pipeline           = ""
    description        = ""
    backup             = ""
    review_date        = ""
    remove_date        = ""
    location           = "Australia East"
  }

  common_tags = merge(local.default_common_tags, var.common_tags)

  default_route_table = {
    "z-${var.envrionment}-to_obeafw-rt" = {
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
        name = "z-${var.envrionment}-to_obeafw-rt"
      }
    }
  }
  route_tables = var.provision_default_route_table ? merge(local.default_route_table, var.route_tables) : var.route_tables

  vnet_rg_name = coalesce(var.vnet_rg_name, "${var.envrionment}-vnet-rg")
}
