# Security groups

## specific ip

- this module was made with the idea that it would be used in creating an rke2 node
  - I think the module was too specific in a few places
    - I don't think the module should include access for CI or any one entity to the project
      - this infers the ssh key and specific ips added to security groups should de removed
- how do we install or manage things when we create them?
- any object further down the line will be able to add a new security group to give access to that object
  - we expect to give a project level entry point in the loadbalancer with an eip
  - the security group types should reflect how we want to expose the load balancer
- how does a user access their infrastructure?
  - any user should be able to add themselves to a project without affecting any of the other parts of the project
    - an entity from outside the project could be some client or a user
    - a user might need an ssh key, adding them to a server that already exists would require something logging into the server and adding them
      - the "something" could be a CI runner, or it could be something like Vault
      - that something will need to be able to clean things up if the access changes
   - any client will need their IP added to the project (unless it is open to the internet)

## add client module

- I think we have identified a new module to help manage a project
- the project_client module would have its own lifecycle, right?
- each client would have its own lifecycle
- maybe it doesn't need its own module?
- would a map of clients in this module work better?

- lets take a concrete example
  - adding the CI to a project is an important client because the CI will provision the basic needs of the servers
  - CI keys and IPs are ephemeral, so they need to be created and removed before and after contact
  - the CI will need:
    - its ip added to the load balancer to access services
    - a security group with its ip
      - allowing ingress to port 22 for ssh access
      - allowing ingress to port 6443 for kubernetes access
      - allowing ingress to port 443 for rancher access
    - this security group will need to be added to servers
      - the idea is not to add the security group to the load balancer
        - this is because once it has access to the servers it can access kubernetes directly from one of the control plane nodes
    - its ssh key added to servers to enable ssh access
  - the server access level of this indicates the need for separation of concerns
    - we don't want this module to manage servers because the expectation is that they don't exist yet when this is run
    - keeping this lenear progression helps users fit things in their head
