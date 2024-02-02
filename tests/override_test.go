package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates no objects, but validates that they exist
// this is a typical experience when you already have all the things you need to access servers in a project
// but you want to make sure the access objects exist before building anything else
func TestOverride(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "override"
	region := "us-west-1"
	owner := "terraform-ci@suse.com"

	defer teardown(t, directory)

	keyPair := setupKeyPair(t, directory, region, owner, uniqueID)
	defer teardownKeyPair(t, keyPair)

	securityGroupId, securityGroupName := setupSecurityGroup(t, directory, region, owner)
	defer teardownSecurityGroup(t, region, securityGroupId)

	terraformVars := map[string]interface{}{
		"identifier":          uniqueID,
		"key_name":            keyPair.Name,
		"security_group_name": securityGroupName,
	}
	terraformOptions := setup(t, directory, region, terraformVars)

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
