# Pre-requisite
## Install go-lang, mag
# How-to:
## Develop your code
## mage your friend
1. Unit test
	
	```
	mage unit
	```

2. Integration test
	
	```
	mage integration
	```

3. Format

	```
	mage format
	```

4. Clean

	```
	mage clean
	```

5. All in one

	```
	mage
	```

## Fix the issues
## Have fun
# Dive in
## magefile.go

	`magefile.go` in Go-lang is the `Makefile` in C

	```
	cat magefile.go
	```
## Test
### test/unit/plan_test.go
Essentially this issues `terraform plan` using terraform code in `test/fixtures/main.tf`
### test/integration/apply_test.go
This issues `terrafrom apply` using same terraform code in `test/fixtures/main.tf`
### test/fixtures/main.tf
This is the sample code used by unit and integration tests.