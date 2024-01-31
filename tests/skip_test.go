package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestSkipVpc(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "skipvpc"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

func TestSkipSubnet(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "skipsubnet"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSkipSecurityGroup(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "skipsecuritygroup"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
func TestSkipSsh(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "skipssh"
	region := "us-west-1"

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
