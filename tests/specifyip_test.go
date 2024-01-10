package test

import (
	"fmt"
	"log"
	"net"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// this test generates all objects, no overrides
func TestIp(t *testing.T) {
	t.Parallel()
	uniqueID := random.UniqueId()
	directory := "specifyip"
	region := "us-west-1"
	ip := GetOutboundIP().String()

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-test-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"key_name": keyPairName,
		"key":      keyPair.PublicKey,
		"ip":       ip,
	}
	terraformOptions := setup(t, directory, region, terraformVars)
	defer teardown(t, directory)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}

// Get preferred outbound ip of this machine
func GetOutboundIP() net.IP {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	localAddr := conn.LocalAddr().(*net.UDPAddr)

	return localAddr.IP
}
