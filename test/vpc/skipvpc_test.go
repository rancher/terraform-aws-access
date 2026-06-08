package vpc

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	util "github.com/rancher/terraform-aws-access/test"
)

// this test generates all objects, no overrides
func TestSkipvpc(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueID()
	}
	directory := "skipvpc"
	region := os.Getenv("AWS_REGION")

	terraformVars := map[string]any{
		"identifier": uniqueID,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)
	defer util.Teardown(t, directory)
	defer terraform.DestroyContext(t, t.Context(), terraformOptions)
	terraform.InitAndApplyContext(t, t.Context(), terraformOptions)
}
