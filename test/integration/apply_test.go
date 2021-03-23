package integration

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApply(t *testing.T) {
	tfOptions := &terraform.Options{
		TerraformDir: "../fixtures/",
		Vars:         map[string]interface{}{},
		EnvVars: map[string]string{
			"ARM_SUBSCRIPTION_ID": "xxxx",
		},
	}
	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)
}
