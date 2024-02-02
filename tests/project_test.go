package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test adds security group and subnet, but overrides vpc and ssh key
// this is a typical experience when you want to start a new project in a new subnet
// and the vpc is outside of your control
func TestProject(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "project"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	keyPair := setupKeyPair(t, directory, region, owner, uniqueID)
	defer teardownKeyPair(t, keyPair)
	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"key_name":   keyPair.Name,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
