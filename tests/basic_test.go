package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates all objects, no overrides
func TestBasic(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "basic"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-test-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
