//+build mage

package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/magefile/mage/mg"

	"github.com/magefile/mage/sh"
)

var Default = Full

// Task to kick off Unit test
func Unit() error {
	mg.Deps(Clean)
	mg.Deps(Format)
	fmt.Println("Running unit tests...")
	return sh.RunV("go", "test", "./test/unit/", "-v")
}

// Task to clean up
func Clean() error {
	fmt.Println("Clearning...")
	return filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if info.IsDir() && info.Name() == "vendor" {
			return filepath.SkipDir
		}
		if info.IsDir() && info.Name() == ".terraform" {
			os.RemoveAll(path)
			fmt.Printf("Removed '%v'\n", path)
			return filepath.SkipDir
		}
		if !info.IsDir() && (info.Name() == "terraform.tfstate" || info.Name() == "terraform.tfstate.backup") {
			os.Remove(path)
			fmt.Printf("Removed '%v'\n", path)
		}
		return nil
	})
}

// Function that formats both Terraform and Go code
func Format() error {
	fmt.Println("Formating both Terraform and Go files...")

	if err := sh.RunV("terraform", "fmt", "-recursive", "."); err != nil {
		return err
	}
	return sh.RunV("go", "fmt", "./test/unit/")
}

// Task to kick off Integration test
func Integration() error {
	mg.Deps(Clean)
	mg.Deps(Format)

	fmt.Println("Running integration tests...")
	return sh.RunV("go", "test", "./test/integration/")
}

// Task to run both unit and integration tests
func Full() {
	mg.Deps(Unit)
	mg.Deps(Integration)
}
