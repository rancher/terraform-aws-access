package test

import (
	"fmt"
	"log"
	"net"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIp(t *testing.T) {
	t.Parallel()
	uniqueID := os.Getenv("IDENTIFIER")
	if uniqueID == "" {
		uniqueID = random.UniqueId()
	}
	directory := "specifyip"
	region := "us-west-1"
	ip := GetOutboundIP().String()

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)
	keyPairName := fmt.Sprintf("terraform-aws-access-%s-%s", directory, uniqueID)
	terraformVars := map[string]interface{}{
		"identifier": uniqueID,
		"key_name":   keyPairName,
		"key":        keyPair.PublicKey,
		"ip":         ip,
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
