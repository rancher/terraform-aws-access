package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

// this test adds security group and ssh key, but overrides vpc and subnet
// this is a typical experience when vpc and subnet is managed by a different group
// thus generating only unshared or "personal" objects
func TestPersonal(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/personal",
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
