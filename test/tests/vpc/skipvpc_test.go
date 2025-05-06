package vpc

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
  util "github.com/rancher/terraform-aws-access/test/tests"
)

// this test generates all objects, no overrides
func TestSkipvpc(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "skipvpc"
  region := os.Getenv("AWS_REGION")

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
	}
	terraformOptions := util.Setup(t, directory, region, terraformVars)
	defer util.Teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
