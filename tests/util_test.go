package test

import (
	"fmt"
	"os"
	"testing"

	a "github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/ec2"
	aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func teardown(t *testing.T, directory string) {
	err := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform", directory))
	require.NoError(t, err)
	err1 := os.RemoveAll(fmt.Sprintf("../examples/%s/.terraform.lock.hcl", directory))
	require.NoError(t, err1)
	err2 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate", directory))
	require.NoError(t, err2)
	err3 := os.RemoveAll(fmt.Sprintf("../examples/%s/terraform.tfstate.backup", directory))
	require.NoError(t, err3)
}

func setup(t *testing.T, directory string, region string, terraformVars map[string]interface{}) *terraform.Options {

	retryableTerraformErrors := map[string]string{
		// The reason is unknown, but eventually these succeed after a few retries.
		".*unable to verify signature.*":             "Failed due to transient network error.",
		".*unable to verify checksum.*":              "Failed due to transient network error.",
		".*no provider exists with the given name.*": "Failed due to transient network error.",
		".*registry service is unreachable.*":        "Failed due to transient network error.",
		".*connection reset by peer.*":               "Failed due to transient network error.",
		".*TLS handshake timeout.*":                  "Failed due to transient network error.",
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../examples/%s", directory),
		// Variables to pass to our Terraform code using -var options
		Vars: terraformVars,
		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": region,
			"AWS_REGION":         region,
		},
		RetryableTerraformErrors: retryableTerraformErrors,
	})
	return terraformOptions
}

func setupKeyPair(t *testing.T, directory string, region string, owner string, uniqueID string) *aws.Ec2Keypair {
	// Create an EC2 KeyPair that we can find in the module
	keyPairName := fmt.Sprintf("terraform-aws-access-test-%s-%s", directory, uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, region, keyPairName)
	// tag the key pair
	client, err1 := aws.NewEc2ClientE(t, region)
	require.NoError(t, err1)
	input := &ec2.DescribeKeyPairsInput{
		KeyNames: []*string{a.String(keyPairName)},
	}
	result, err2 := client.DescribeKeyPairs(input)
	require.NoError(t, err2)
	aws.AddTagsToResource(t, region, *result.KeyPairs[0].KeyPairId, map[string]string{"Name": keyPairName, "Owner": owner})
	return keyPair
}

func teardownKeyPair(t *testing.T, keyPair *aws.Ec2Keypair) {
	aws.DeleteEC2KeyPair(t, keyPair)
}

func setupSecurityGroup(t *testing.T, directory string, region string, owner string) (string, string) {
	// Create an EC2 Security Group that we can find in the module
	uniqueID := random.UniqueId()
	name := fmt.Sprintf("terraform-aws-access-test-%s-%s", directory, uniqueID)
	// assume we are attaching to a default VPC
	vpc := aws.GetDefaultVpc(t, region)

	client, err1 := aws.NewEc2ClientE(t, region)
	require.NoError(t, err1)
	securityGroupInput := &ec2.CreateSecurityGroupInput{
		Description: a.String(name),
		GroupName:   a.String(name),
		VpcId:       a.String(vpc.Id),
	}
	securityGroup, err2 := client.CreateSecurityGroup(securityGroupInput)
	require.NoError(t, err2)
	aws.AddTagsToResource(t, region, *securityGroup.GroupId, map[string]string{"Name": name, "Owner": owner})
	securityGroupRuleInput := &ec2.AuthorizeSecurityGroupEgressInput{
		GroupId: securityGroup.GroupId,
		IpPermissions: []*ec2.IpPermission{
			{
				FromPort:   a.Int64(80),
				IpProtocol: a.String("tcp"),
				IpRanges: []*ec2.IpRange{
					{
						CidrIp: a.String("10.0.0.0/16"),
					},
				},
				ToPort: a.Int64(80),
			},
		},
	}
	_, err3 := client.AuthorizeSecurityGroupEgress(securityGroupRuleInput)
	require.NoError(t, err3)
	return *securityGroup.GroupId, name
}

func teardownSecurityGroup(t *testing.T, region string, securityGroupId string) {
	client, err1 := aws.NewEc2ClientE(t, region)
	require.NoError(t, err1)
	input := &ec2.DeleteSecurityGroupInput{
		GroupId: a.String(securityGroupId),
	}
	_, err2 := client.DeleteSecurityGroup(input)
	require.NoError(t, err2)
}
