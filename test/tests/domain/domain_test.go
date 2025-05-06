package domain

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
  util "github.com/rancher/terraform-aws-access/test/tests"
)

// this test generates all objects, no overrides
func TestDomain(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	zone := os.Getenv("ZONE")
	directory := "domain"
  region := os.Getenv("AWS_REGION")

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"zone":     	zone,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

func TestCert(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	zone := os.Getenv("ZONE")
	directory := "cert"
	region := "us-west-1"

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"zone":     	zone,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
