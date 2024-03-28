# Domain

## multi-phase deployments and select when not creating paradigm
- we need to have the ability to select a domain so that we can verify its existence in multi phase deployments
  - this means assume that this module has already run, but in a different phase and nothing is in this phase's state
- select options allow us to decide to deploy some resources at earlier phases, while still keeping them in state
- select when not create gives us unified output for modules and the ability to make assumptions about available data and outputs
- select is therefore a special use case, so we should ask the user if that is what they want

## skip deployments options
- while being able to select reources that were deployed in an earlier phase it is also good to be able to choose to deploy resources later
- skip options work like feature flags
- skip options enable unit testing modules
- skip options allow us to decide to deploy some resources in later phases
  - select options allow us to decide to deploy some resources at earlier phases
- skip is a special use case, so we should ask the user if that is what they want

## how do we know to look for a domain vs creating a domain?
- if creating a zone, we need to create a domain
- can we select a zone, but create a domain?
  - no, we want it coupled and encapsulated
    - in this situation the user has a zone that maybe serves multiple projects, they want a domain in the zone for this project
    - we could suggest that the user create a zone for the project, but it doesn't need to be a top level zone
    - the user can have a top level zone "example.com" and a project level zone "project.example.com",
      then a project level domain "entry.project.example.com"
      - the user can then have a cname for the project level zone pointing to the project level domain "project.example.com -> entry.project.example.com"
    - this couples the zone to the domain, and it also gives us a generic domain name to use
    - from the user's perspective they have a domain "project.example.com" that works for their project
    - while we are actually generating a zone, domain, and cname, the user doesn't need to control this
    - selecting a domain is a special use case, so maybe we ask the user if that is what they want
- I think this is addressed with the specialized use case section below

## specialized use cases
- it seems I have identified a generalized use case for internal modules or features
- maybe every feature should have some argument to either skip or select
  - this makes sense since these are not mutually exclusive
    - if you want to select a module you don't want to skip it
- this makes the default behavior for any feature to be creation
  - this has implecations on new feature additions
  - maybe we have an 'experimental' phase where new features are skipped by default
    - I think this is too complicated
  - then after a period of time we flip the skip default?
    - this breaks the interface, something we really don't want to do
    - breaking changes should result in major version numbers
  - what if we make the default behavior to be skipping a feature
    - then users will need to enable each feature individually
    - I don't like this because it makes the user interface huge and overwhelming
    - I also don't like this because the initial set of features are enabled by default
      - then we have 'core' and 'additional' features, which is too complicated
  - I think the best compromise is to expect users to pin the major version in ther versions file if they don't want breaking changes
    - this is suggested by Hashicorp, so it should be standard practice
    - the default posture for features can be create, with the option to skip
    - skipping the feature allows you to easily update to the latest major without implecations, but there is some change necessary
- what should we name the argument?
  - options: 'skip', 'select', or 'create' defaulting to 'create'
    - skip is like 'no', create is like 'yes', select is like 'kinda'
  - use_domain, domain_use, domain_usage_level, domain_usage
  - https://www.phind.com/search?cache=pxw1uu72n85u69ti4p4v8hmg
  - domain_use_strategy per that conversation ^^
  - this will also extrapolate to blah_use_strategy for any feature
    - I will need to backfill this argument, but that will have no effect on the current usage since create is the default
  - in cases where I already have something I will need to alter the interface which is a breaking change, so there will need to be notes on this

## TLD
- I don't like the idea of a demo user having to go buy a domain manually for this to work, I would rather generate one for them
- I can't seem to get a valid cert when creating a TLD on our account, so until that works we are stuck with it
