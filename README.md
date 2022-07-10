# Azure Landing Zone VNET Terraform Module

The private [Network module](https://app.terraform.io/app/twl/registry/modules/private/twl/network/azure/1.1.16) creates Azure vnet and peer it with the commvault and hub vnets.

## Resources

1. azurerm_resource_group.this_rg

    The resource group called `${var.environment}-vnet-rg` by default

1. azurerm_network_security_group.this_nsg

    A network security group

1. azurerm_route_table.this_rt["`z-{var.environment}}-to_obeafw-rt`"]

    An outbound route table for the firewall with the following routes:

    - blackhole_fw_mgmt
    - blackhole_fw_public
    - default_2_LB_obewfw

1. azurerm_virtual_network.vnet

    A virtual network

1. azurerm_subnet.subnet

    A subnet with specify address_prefixes.

1. azurerm_virtual_network_peering

    - peering_src - the new created virtual network
    - peering_dest - the specify vnets

      - var.hub_vnet_id
      - var.commvault_vnet_id

1. azurerm_subnet_route_table_association.vm_subnet

    Associates the Route Table `this_rt` with the Subnet within a Virtual Network.

### Azure Providers

The Terraform module has three build-in Azure providers.

- Default provider which uses TF `ARM_SUBSCRIPTION_ID` environment variable. New resources are be created under this subscription.

    ```shell
    provider "azurerm" {
      subscription_id = "env.ARM_SUBSCRIPTION_ID"
      features {}
    }
    ```

1. Hub provider which is the connectivity subscription. The hub vnet is under this subscription

    ```shell
    provider "azurerm" {
      alias           = "hub"
      subscription_id = "c4855b85-e4fb-4ae6-9db6-34dc74d21cc4"
      features {}
    }
    ```

1. Management provider which is the management subscription. The commvault vnet is under this subscription.

    ```shell
    provider "azurerm" {
      alias           = "management"
      subscription_id = "5b74d5cd-8e57-4e60-b745-fb2d0c394320"
      features {}
    }
    ```

## How-to test the module with [terratest](https://github.com/gruntwork-io/terratest)

### Pre-requisite

#### Install go-lang

Please follow the go [installation guide](https://go.dev/doc/install) to install go-lang.

#### Install mage

Meta is a Make/rake-like dev tool using Go. Please follow the [installation guide](https://github.com/magefile/mage#installation) to install mage.

#### Install modules for testing

```bash
go mod download github.com/gruntwork-io/terratest
go mod download github.com/magefile/mage
go get github.com/gruntwork-io/terratest/modules/ssh@v0.32.16
go get github.com/gruntwork-io/terratest/modules/terraform@v0.32.16
```

### Develop your code with mage

1. Unit test

    ```bash
    mage unit
    ```

1. Integration test

    ```bash
    mage integration
    ```

1. Format

    ```bash
    mage format
    ```

1. Clean

    ```bash
    mage clean
    ```

1. All in one

    ```bash
    mage
    ```

### Dive in

#### magefile.go

`magefile.go` in Go-lang is the `Makefile` in C

```bash
cat magefile.go
```

#### Test

##### test/unit/plan_test.go

Essentially this issues `terraform plan` using terraform code in `test/fixtures/main.tf`

##### test/integration/apply_test.go

This issues `terraform apply` using same terraform code in `test/fixtures/main.tf`

##### test/fixtures/main.tf

This is the sample code used by unit and integration tests.
