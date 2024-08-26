# Terraform AWS Access

WARNING! The subnets argument must not be derived from an apply time resource.

## Recent Changes

- Dependency chain resolution
  I was getting some intermittent issues attempting to destroy EIPs while also destroying the load balancer.
  The error was something like "error disassociating EC2 address".
  I believe AWS is automatically disassociating the EIP when destroying the load balancer.
  To resolve I am setting the explicit dependency for the load balancer on the EIP addresses.
  This should force the EIPs to be deleted before the load balancer.

- IPv6 only and Dualstack Support BREAKING CHANGES!
  A few interface changes were necessary to inform the module about options which are now ambiguous.
  You must now specify "ip_family" in the load balancer access address options.
  There is a new "vpc_type" option which tells the module your intention to use IPv6 only, dualstack, or ipv4 only.
  The vpc_type option facilitated a new major version of the module.
  Specifying "ip_family" in the access addresses is now required.
  A new "ipv6" example is provided to show how to enable that, as well as "dualstack".
  There can be some confusion if looking at the AWS objects directly,
  many of them are dualstack for the ipv6 only use case, but ipv4 isn't allowed.
  When deploying an ipv6 project there is no internet gateway for ipv4, allowing only ipv6 at the edge of your vpc.
  Within the VPC you can technically use ipv4, but only on internal addressing, and it is not recommended.
  You can restrict this by not adding ipv4 access addresses to the servers.

- Private IP address for load balancer
  Along with assigning an EIP for public access we now also attach a private ip address to the load balancer.
  The last available IP address in the subnet is used.
  This helps avoid IP address conflicts with instances in the subnet.
  We now provision a subnet mapping for every subnet, and an elastic IP for each mapping.
  We then assign all the EIPs to the domain.
  This enables cross-zone load balancing with DNS round robin while also supplying a specific IP to each AZ.

## AWS Access

The first step to using the AWS modules is having an AWS account,
 [here](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html) is a document describing this process.
You will need an API access key id and API secret key,
 you can get the API keys [following this tutorial](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).
The Terraform AWS provider uses the AWS Go SDK, which allows the use of either environment variables or config files for authentication.
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-settings

You do not need the AWS cli to generate the files, just place them in the proper place and Terraform will find and read them.
In development, we use environment variables to configure the AWS provider and load them by sourcing an RC file.
In CI we use OIDC connection to AWS to authenticate.

```
export AWS_ACCESS_KEY_ID='ABC123'
export AWS_SECRET_ACCESS_KEY='abc123'
export AWS_REGION='us-west-1'
```

These help the tests set you as the owner on the testing infra and generate the proper key.
The `.envrc` file sources `.rcs` file which assumes a local file at path `~/.config/aws/default` exists with the above information.

## Examples

### Local State

The specific use case for the example modules is temporary infrastructure for testing purposes.
With that in mind, it is not expected that we manage the resources as a team, therefore the state files are all stored locally.
If you would like to store the state files remotely, add a terraform backend file (`*.name.tfbackend`) to your implementation module.
https://www.terraform.io/language/settings/backends/configuration#file

## Development and Testing

### Paradigms and Expectations

Please make sure to read [terraform.md](./terraform.md) to understand the paradigms and expectations that this module has for development.

### Environment

It is important to us that all collaborators have the ability to develop in similar environments, so we use tools which enable this as much as possible.
These tools are not necessary, but they can make it much simpler to collaborate.

* I use [nix](https://nixos.org/) that I have installed using [their recommended script](https://nixos.org/download.html#nix-install-macos)
* I use [direnv](https://direnv.net/) that I have installed using brew.
* I simply use `direnv allow` to enter the environment
* I navigate to the `tests` directory and run `go test -v -timeout=5m -parallel=10`
* To run an individual test I nvaigate to the `tests` directory and run `go test -v -timeout=5m -run <test function name>`
  * eg. `go test -v -timeout=5m -run TestBasic`

Our continuous integration tests in the GitHub [ubuntu-latest runner](https://github.com/actions/runner-images/blob/main/images/linux/Ubuntu2204-Readme.md), which has many different things installed, we use nix to add dependencies.

### Override Tests

You may want to test this code with slightly different parameters for your environment.
Check out [Terraform override files](https://developer.hashicorp.com/terraform/language/files/override) as a clean way to modify the inputs without accidentally committing any personalized code.
