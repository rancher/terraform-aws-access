# Terraform AWS Access

WARNING! The subnets argument must not be derived from an apply time resource.

## Recent Changes

- Optional Certificate generation
  If you would like to terminate TLS on your server this module can generate a real Let's encrypt certificate for you.
  This is done using the `cert_use_strategy` argument, it is set to 'skip' by default, but if you set it to `create` it will create a new certificate for you. It saves the cert in an IAM object and then use that as the source of truth for the cert.

- Manage external access

  You can now add ingress from external addresses by cidr and port.
  This will generate security group rules with 'from' and 'to' having the port number specified.
  The input is a map of port to list of CIDRs, eg. `{"443" = ["1.1.1.1/32","2.2.2.2/32"], "6443" = ["3.3.3.3/24"]}`.

- BREAKING CHANGES!

  While adding the loadbalancer and domain to this module it kinda seems like the ssh key shouldn't be included.
  I also found a more standardized approach to how to skip or select modules.
  When adding a load balancer I discovered that subnets will need to be tied to availability zones.
  I also found that it was easier to combine the subnet input to something more complex, but should be easy enough to figure out
  1. No longer managing ssh keys with this module!
  2. The <name>-use-strategy variables now determine how modules are used (create, skip, or select)
  3. Subnets inputs needed to change to incorporate high availability
  With this is a massive change in the interface, this is a major break from the previous version, but I believe necessary for its growth.

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
