provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = "c4855b85-e4fb-4ae6-9db6-34dc74d21cc4"
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = "5b74d5cd-8e57-4e60-b745-fb2d0c394320"
  features {}
}

variable "vnet_rg_name" {
  description = "The name of resource group to host virtual network"
  default     = ""
  type        = string
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The name of this environment"
  default     = "prod"
  type        = string
}

# This variable is litterally a workaround for the stupid data resource in that Azure VNET module to check whether the specified resource group exists or not
variable "create_vnet" {
  description = "Whether to create VNET"
  default     = true
  type        = bool
}

variable "location" {
  description = "Location of the deployment"
  default     = "australiaeast"
  type        = string
}

variable "vnet_name_prefix" {
  description = "Name prefix of the virtual network"
  type        = string
  default     = ""
}

variable "vnet_address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = []
}

variable "nsg_associations" {
  description = "A map of subnet name to name prefix of Network Security Groups"
  type        = map(string)

  default = {}
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = []
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "A map of subnet name to enable/disable private link endpoint network policies on the subnet."
  type        = map(bool)
  default     = {}
}

variable "hub_vnet_id" {
  description = "VNET ID of hub network"
  type        = string
  default     = "/subscriptions/c4855b85-e4fb-4ae6-9db6-34dc74d21cc4/resourceGroups/prod-vnet-rg/providers/Microsoft.Network/virtualNetworks/z-prod-hub-vnet-7XUf8Y"
}

variable "peer_with_hub" {
  description = "Whether the current vnet peers with hub network"
  type        = bool
  default     = true
}

variable "peer_with_commvault_vnet" {
  description = "Whether the current vnet peers with CommVault network"
  type        = bool
  default     = false
}

variable "commvault_vnet_id" {
  description = "VNET ID of CommVault network"
  type        = string
  default     = "/subscriptions/5b74d5cd-8e57-4e60-b745-fb2d0c394320/resourceGroups/prod-commvault-rg/providers/Microsoft.Network/virtualNetworks/z-prod-commvault-vnet-aKtkTh"
}

variable "common_tags" {
  description = "Common tags applied to all the resources created in this module"
  type        = map(string)
  default     = {}
}

variable "vnet_rg_tags" {
  description = "Tags applied to the VNET resource group"
  type        = map(string)
  default     = {}
}

variable "vnet_tags" {
  description = "Tags applied to the VNET"
  type        = map(string)
  default     = {}
}

variable "provision_default_route_table" {
  description = "Whether to provision the default route table"
  default     = true
  type        = bool
}

variable "route_tables" {
  description = "Route tables"
  default     = {}
}

variable "subnet_delegation" {
  description = "A map of subnet name to delegation block on the subnet"
  type        = map(map(any))
  default     = {}
}

variable "route_table_association" {
  description = "Specify which route table associates which subnet"
  type        = map(string)
  default     = {}
}
