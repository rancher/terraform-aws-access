package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

// this test adds security group and subnet, but overrides vpc and ssh key
// this is a typical experience when you want to start a new project in a new subnet,
//
//	and the vpc is outside of your control
func TestProject(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/project",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
