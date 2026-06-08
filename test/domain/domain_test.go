package domain

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-aws-access/test"
)

// this test generates all objects, no overrides
func TestDomain(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueID()
	}
	zone := os.Getenv("ZONE")
	directory := "domain"
	region := os.Getenv("AWS_REGION")

	terraformVars := map[string]any{
		"identifier": uniqueID,
		"zone":       zone,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.DestroyContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}

func TestCert(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueID()
	}
	zone := os.Getenv("ZONE")
	directory := "cert"
	region := "us-west-1"

	terraformVars := map[string]any{
		"identifier": uniqueID,
		"zone":       zone,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)

	defer util.Teardown(t, directory)
	defer terraform.DestroyContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
