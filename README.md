# How-to test the module with [terratest](https://github.com/gruntwork-io/terratest)

## Pre-requisite

### Install go-lang

Please follow the go [installation guide](https://go.dev/doc/install) to install go-lang.

### Install mage

Meta is a Make/rake-like dev tool using Go. Please follow the [installation guide](https://github.com/magefile/mage#installation) to install mage.

### Install modules for testing

```bash
go mod download github.com/gruntwork-io/terratest
go mod download github.com/magefile/mage
go get github.com/gruntwork-io/terratest/modules/ssh@v0.32.16
go get github.com/gruntwork-io/terratest/modules/terraform@v0.32.16
```

## Develop your code with mage

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

## Dive in

### magefile.go

`magefile.go` in Go-lang is the `Makefile` in C

```bash
cat magefile.go
```

### Test

#### test/unit/plan_test.go

Essentially this issues `terraform plan` using terraform code in `test/fixtures/main.tf`

#### test/integration/apply_test.go

This issues `terraform apply` using same terraform code in `test/fixtures/main.tf`

#### test/fixtures/main.tf

This is the sample code used by unit and integration tests.
