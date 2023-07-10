package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

// this test generates all objects, no overrides
func TestBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
