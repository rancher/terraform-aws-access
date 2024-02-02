package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSkipVpc(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "skipvpc"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("tf-%s-%s", directory, uniqueID)
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

func TestSkipSubnet(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "skipsubnet"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("tf-%s-%s", directory, uniqueID)
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
func TestSkipSecurityGroup(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "skipsecuritygroup"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("tf-%s-%s", directory, uniqueID)
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
func TestSkipSsh(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "skipssh"
	region := "us-west-1"

	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
