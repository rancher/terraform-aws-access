# Changelog

## [1.2.0](https://github.com/rancher/terraform-aws-access/compare/v1.1.1...v1.2.0) (2024-03-08)


### Features

* add ability to skip specific ip sg ([#38](https://github.com/rancher/terraform-aws-access/issues/38)) ([a0c8b10](https://github.com/rancher/terraform-aws-access/commit/a0c8b103e9448d4eb0c94895941e6c3dfcccc5c3))

## [1.1.1](https://github.com/rancher/terraform-aws-access/compare/v1.1.0...v1.1.1) (2024-02-09)


### Bug Fixes

* update terraform version to new req 1.5 ([#36](https://github.com/rancher/terraform-aws-access/issues/36)) ([7d55c41](https://github.com/rancher/terraform-aws-access/commit/7d55c4116e3763ee04c321c4a743d3fdb0267381))

## [1.1.0](https://github.com/rancher/terraform-aws-access/compare/v1.0.2...v1.1.0) (2024-02-07)


### Features

* add the option to map a public ip to servers on subnet ([#33](https://github.com/rancher/terraform-aws-access/issues/33)) ([c622311](https://github.com/rancher/terraform-aws-access/commit/c6223110d0f4a4fa9794fc3226dbc0f03d0ad92e))


### Bug Fixes

* remove unncessary store steps ([#35](https://github.com/rancher/terraform-aws-access/issues/35)) ([e5f6034](https://github.com/rancher/terraform-aws-access/commit/e5f60342a087b6460038c00f7ddc088f5de0fd45))

## [1.0.2](https://github.com/rancher/terraform-aws-access/compare/v1.0.1...v1.0.2) (2024-02-02)


### Bug Fixes

* add names specific to tests in examples ([#32](https://github.com/rancher/terraform-aws-access/issues/32)) ([1653d16](https://github.com/rancher/terraform-aws-access/commit/1653d1627800e378d4d6422d93e27b7f3c9cfd80))
* update workflow to include id tag, cleanup, new flake, etc ([#30](https://github.com/rancher/terraform-aws-access/issues/30)) ([bac9943](https://github.com/rancher/terraform-aws-access/commit/bac9943fb9c764bf0afb17ceede794d2d08e0dee))

## [1.0.1](https://github.com/rancher/terraform-aws-access/compare/v1.0.0...v1.0.1) (2024-01-31)


### Bug Fixes

* bump actions/cache from 3 to 4 ([#25](https://github.com/rancher/terraform-aws-access/issues/25)) ([8e46a19](https://github.com/rancher/terraform-aws-access/commit/8e46a19c096a6f3086df0a89ce9c86e404a780e4))
* bump peter-evans/create-or-update-comment from 3 to 4 ([#28](https://github.com/rancher/terraform-aws-access/issues/28)) ([0982d67](https://github.com/rancher/terraform-aws-access/commit/0982d67cfecbe228628e4cd90020f57805d2d6dc))

## [1.0.0](https://github.com/rancher/terraform-aws-access/compare/v0.1.4...v1.0.0) (2024-01-23)


### ⚠ BREAKING CHANGES

* add the ability to explicitly skip parts of the module ([#26](https://github.com/rancher/terraform-aws-access/issues/26))

### Features

* add the ability to explicitly skip parts of the module ([#26](https://github.com/rancher/terraform-aws-access/issues/26)) ([a7445f9](https://github.com/rancher/terraform-aws-access/commit/a7445f999bb82b757bd09b281ce06b4bbc50711e))

## [0.1.4](https://github.com/rancher/terraform-aws-access/compare/v0.1.3...v0.1.4) (2024-01-10)


### Bug Fixes

* only chomp if necessary ([#23](https://github.com/rancher/terraform-aws-access/issues/23)) ([fca353d](https://github.com/rancher/terraform-aws-access/commit/fca353dd81dfb967f294b2f6d4cacc1eb5d3592c))

## [0.1.3](https://github.com/rancher/terraform-aws-access/compare/v0.1.2...v0.1.3) (2023-12-19)


### Bug Fixes

* remove unnecessary lifecycle ignore ([#21](https://github.com/rancher/terraform-aws-access/issues/21)) ([6178353](https://github.com/rancher/terraform-aws-access/commit/61783534ae7377cd8d91c3545deed25ffa3c820f))

## [0.1.2](https://github.com/rancher/terraform-aws-access/compare/v0.1.1...v0.1.2) (2023-12-12)


### Bug Fixes

* bump actions/setup-go from 4 to 5 ([#18](https://github.com/rancher/terraform-aws-access/issues/18)) ([436f1d5](https://github.com/rancher/terraform-aws-access/commit/436f1d5ef7297ffee9d4873d4d253dd4aede78fb))
* bump google-github-actions/release-please-action from 3 to 4 ([#16](https://github.com/rancher/terraform-aws-access/issues/16)) ([7125713](https://github.com/rancher/terraform-aws-access/commit/71257130f265f82c8622fd61991c0d54a79e1e86))
* Fix ip discover ([#19](https://github.com/rancher/terraform-aws-access/issues/19)) ([4d1867e](https://github.com/rancher/terraform-aws-access/commit/4d1867e53e77b9dab36a789034e08f8c759802cb))
* Use ipinfo ([#20](https://github.com/rancher/terraform-aws-access/issues/20)) ([1c4cfdb](https://github.com/rancher/terraform-aws-access/commit/1c4cfdbf33434ab0e2ed4bb0d5a37f5c2acdb915))

## [0.1.1](https://github.com/rancher/terraform-aws-access/compare/v0.1.0...v0.1.1) (2023-11-29)


### Bug Fixes

* Add release ([#14](https://github.com/rancher/terraform-aws-access/issues/14)) ([ca7a6b1](https://github.com/rancher/terraform-aws-access/commit/ca7a6b16fa06755d5b4daf505c524f390fd1724a))

## [0.1.0](https://github.com/rancher/terraform-aws-access/compare/v0.0.8...v0.1.0) (2023-10-30)


### Features

* generate new security group rules and add automatic updates ([45c7b33](https://github.com/rancher/terraform-aws-access/commit/45c7b3351aed0c8f34e641c0f93d4c9133f0b4c9))


### Bug Fixes

* dependebot commits should use standard commit format ([#13](https://github.com/rancher/terraform-aws-access/issues/13)) ([1eef628](https://github.com/rancher/terraform-aws-access/commit/1eef628ffa006f81b7d3adc724061e6fc04932aa))
