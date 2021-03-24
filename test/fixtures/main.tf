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
  route_table_association = {
    "subnet-1" = "z-prod-to_obeafw-rt"
  }
}
