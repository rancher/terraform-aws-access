package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test adds security group and ssh key, but overrides vpc and subnet
// this is a typical experience when vpc and subnet is managed by a different group
// thus generating only unshared or "personal" objects
func TestPersonal(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "personal"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-test-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"key_name":   keyPairName,
		"key":        keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
