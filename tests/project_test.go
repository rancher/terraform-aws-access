package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test adds security group and subnet, but overrides vpc and ssh key
// this is a typical experience when you want to start a new project in a new subnet
// and the vpc is outside of your control
func TestProject(t *testing.T) {
	t.Parallel()
	directory := "project"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	keyPair := setupKeyPair(t, directory, region, owner)
	defer teardownKeyPair(t, keyPair)
	terraformVars := map[string]interface{}{
		"key_name": keyPair.Name,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
