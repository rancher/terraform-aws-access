package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates all objects, no overrides
func TestSelectvpc(t *testing.T) {
	t.Parallel()
	domain := os.Getenv("DOMAIN")
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "selectvpc"
	region := "us-west-1"

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"domain": domain,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
