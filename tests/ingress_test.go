package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates improves on the basic by adding ingress for the load balancer
func TestIngress(t *testing.T) {
	t.Parallel()
	zone := os.Getenv("ZONE")
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "ingress"
	region := "us-west-1"

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"zone":     	zone,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
