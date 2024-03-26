package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates all objects, no overrides
func TestLoadbalancer(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "loadbalancer"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("tf-test-%s-%s", directory, uniqueID)
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
