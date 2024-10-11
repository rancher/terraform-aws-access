# Changelog

## [3.1.10](https://github.com/rancher/terraform-aws-access/compare/v3.1.9...v3.1.10) (2024-10-11)


### Bug Fixes

* allow domains to be overridden ([#123](https://github.com/rancher/terraform-aws-access/issues/123)) ([7601fae](https://github.com/rancher/terraform-aws-access/commit/7601fae4d9b275684e7756454bbac2f7b83863ce))

## [3.1.9](https://github.com/rancher/terraform-aws-access/compare/v3.1.8...v3.1.9) (2024-10-09)


### Bug Fixes

* use issuer certificate ([#121](https://github.com/rancher/terraform-aws-access/issues/121)) ([ca4ed57](https://github.com/rancher/terraform-aws-access/commit/ca4ed57d387e1d77d0854013fea6717440300732))

## [3.1.8](https://github.com/rancher/terraform-aws-access/compare/v3.1.7...v3.1.8) (2024-10-08)


### Bug Fixes

* add certificate chain ([#118](https://github.com/rancher/terraform-aws-access/issues/118)) ([20d6f4f](https://github.com/rancher/terraform-aws-access/commit/20d6f4fc93b893b29323fdcff790934ce996f975))
* do not check for leftovers ([#120](https://github.com/rancher/terraform-aws-access/issues/120)) ([58d1d82](https://github.com/rancher/terraform-aws-access/commit/58d1d82f8ee3c8bd36a918a99fdac1a629ccfa65))

## [3.1.7](https://github.com/rancher/terraform-aws-access/compare/v3.1.6...v3.1.7) (2024-09-19)


### Bug Fixes

* bump dependency from 4.0.5 to 4.0.6 ([#114](https://github.com/rancher/terraform-aws-access/issues/114)) ([ce7bc5b](https://github.com/rancher/terraform-aws-access/commit/ce7bc5b67eee24becd40ee1f72639dec05638ccb))
* save private key and fix tests ([#115](https://github.com/rancher/terraform-aws-access/issues/115)) ([c5f1ed9](https://github.com/rancher/terraform-aws-access/commit/c5f1ed99684d4396f49354a3879788b302f69499))
* update read me ([#117](https://github.com/rancher/terraform-aws-access/issues/117)) ([84d50aa](https://github.com/rancher/terraform-aws-access/commit/84d50aa52cd8bdd1d5286dadc4f1821df817a1bc))

## [3.1.6](https://github.com/rancher/terraform-aws-access/compare/v3.1.5...v3.1.6) (2024-09-05)


### Bug Fixes

* common name should have full domain ([#112](https://github.com/rancher/terraform-aws-access/issues/112)) ([28d9829](https://github.com/rancher/terraform-aws-access/commit/28d982963332f06ebbb18acfdfb7d0e2c9ccd49f))

## [3.1.5](https://github.com/rancher/terraform-aws-access/compare/v3.1.4...v3.1.5) (2024-08-26)


### Bug Fixes

* remove incorrect note and add new ([#110](https://github.com/rancher/terraform-aws-access/issues/110)) ([06e8d36](https://github.com/rancher/terraform-aws-access/commit/06e8d36b275addb91b215b72decc3a0f928167a1))
* remove old note ([#111](https://github.com/rancher/terraform-aws-access/issues/111)) ([89cc490](https://github.com/rancher/terraform-aws-access/commit/89cc49057df866adf876cfb555bef8076dd88551))
* resolve dependency chain issues ([#108](https://github.com/rancher/terraform-aws-access/issues/108)) ([21a5cb1](https://github.com/rancher/terraform-aws-access/commit/21a5cb1bd0ae02e4283fc65a324053e3e99a71fc))

## [3.1.4](https://github.com/rancher/terraform-aws-access/compare/v3.1.3...v3.1.4) (2024-08-09)


### Bug Fixes

* hard code version 6 address new bit length ([#106](https://github.com/rancher/terraform-aws-access/issues/106)) ([3e90c19](https://github.com/rancher/terraform-aws-access/commit/3e90c1951f90a78dace67bfcd99c3024b0e90dc5))

## [3.1.3](https://github.com/rancher/terraform-aws-access/compare/v3.1.2...v3.1.3) (2024-08-08)


### Bug Fixes

* network new bits match network count ([#104](https://github.com/rancher/terraform-aws-access/issues/104)) ([b030b68](https://github.com/rancher/terraform-aws-access/commit/b030b68afab056f8f3cd27514f2ac3362164f27a))

## [3.1.2](https://github.com/rancher/terraform-aws-access/compare/v3.1.1...v3.1.2) (2024-07-25)


### Bug Fixes

* make native version 6 network ([#100](https://github.com/rancher/terraform-aws-access/issues/100)) ([f09c597](https://github.com/rancher/terraform-aws-access/commit/f09c597beeeb7351e4b2fce7645ba6b72f9160cf))
* revert version 6 native ([#103](https://github.com/rancher/terraform-aws-access/issues/103)) ([f2ee57f](https://github.com/rancher/terraform-aws-access/commit/f2ee57f6eb988531214c0f6658086c8b1075935f))
* update documentation ([#102](https://github.com/rancher/terraform-aws-access/issues/102)) ([99a45f6](https://github.com/rancher/terraform-aws-access/commit/99a45f647c76cd3f2f60cdad0d24ae85715d61fc))

## [3.1.1](https://github.com/rancher/terraform-aws-access/compare/v3.1.0...v3.1.1) (2024-07-25)


### Bug Fixes

* add target group fields ([#95](https://github.com/rancher/terraform-aws-access/issues/95)) ([890b942](https://github.com/rancher/terraform-aws-access/commit/890b942b97b40a5884c0926e21ffb1278772e004))
* health check protocol must be capitalized ([#99](https://github.com/rancher/terraform-aws-access/issues/99)) ([1804984](https://github.com/rancher/terraform-aws-access/commit/18049843dd39d4887644db03108c660a0b295da7))
* make sure protocol is upper case ([#98](https://github.com/rancher/terraform-aws-access/issues/98)) ([8a61e57](https://github.com/rancher/terraform-aws-access/commit/8a61e57d04b0f10bcf698ac9f406fdbff35bc599))
* update documentation ([#97](https://github.com/rancher/terraform-aws-access/issues/97)) ([9037f63](https://github.com/rancher/terraform-aws-access/commit/9037f63f1ea01267124a9cb6eabb4db20784767c))

## [3.1.0](https://github.com/rancher/terraform-aws-access/compare/v3.0.3...v3.1.0) (2024-07-22)


### Features

* enable version 6 access addresses ([#93](https://github.com/rancher/terraform-aws-access/issues/93)) ([402a597](https://github.com/rancher/terraform-aws-access/commit/402a597eda03b8fdf4045a237a363acb2c1860cc))

## [3.0.3](https://github.com/rancher/terraform-aws-access/compare/v3.0.2...v3.0.3) (2024-07-16)


### Bug Fixes

* output public addresses ([#91](https://github.com/rancher/terraform-aws-access/issues/91)) ([d2e2e12](https://github.com/rancher/terraform-aws-access/commit/d2e2e12f4221c0d385af935a29d791f0a1ad95a8))

## [3.0.2](https://github.com/rancher/terraform-aws-access/compare/v3.0.1...v3.0.2) (2024-07-03)


### Bug Fixes

* for loop needs a range ([#89](https://github.com/rancher/terraform-aws-access/issues/89)) ([05a2dea](https://github.com/rancher/terraform-aws-access/commit/05a2dea2a880c14345fb1ba77ba6b4012f7fe999))

## [3.0.1](https://github.com/rancher/terraform-aws-access/compare/v3.0.0...v3.0.1) (2024-06-28)


### Bug Fixes

* dual-stack and load balanced access ([#85](https://github.com/rancher/terraform-aws-access/issues/85)) ([1cfbb72](https://github.com/rancher/terraform-aws-access/commit/1cfbb72f2b875d80f241ac676985fc9fbe8b0679))
* remove extra functions ([#88](https://github.com/rancher/terraform-aws-access/issues/88)) ([1c5dcda](https://github.com/rancher/terraform-aws-access/commit/1c5dcdafcf1f2bc624a93f526205c6acb5a4925c))
* set a retry for the transient error ([#87](https://github.com/rancher/terraform-aws-access/issues/87)) ([1107793](https://github.com/rancher/terraform-aws-access/commit/1107793e78f66b3a18961b982c59181f567fe956))

## [3.0.0](https://github.com/rancher/terraform-aws-access/compare/v2.2.1...v3.0.0) (2024-06-21)


### ⚠ BREAKING CHANGES

* enable dual stack and version 6 addresses ([#80](https://github.com/rancher/terraform-aws-access/issues/80))

### Features

* enable dual stack and version 6 addresses ([#80](https://github.com/rancher/terraform-aws-access/issues/80)) ([ad57058](https://github.com/rancher/terraform-aws-access/commit/ad570588bead0a49c2bda8755ca3052236e4f0e6))


### Bug Fixes

* move cleanup to script for maintainability ([#84](https://github.com/rancher/terraform-aws-access/issues/84)) ([cee0d48](https://github.com/rancher/terraform-aws-access/commit/cee0d480b66e26991c407bea0ef181aa94d3f189))
* remove build result ([#82](https://github.com/rancher/terraform-aws-access/issues/82)) ([71ceb48](https://github.com/rancher/terraform-aws-access/commit/71ceb486c5542e2626d161e875489fa659956924))
* specifying sub network is no longer allowed ([#83](https://github.com/rancher/terraform-aws-access/issues/83)) ([c33d71e](https://github.com/rancher/terraform-aws-access/commit/c33d71ee1066b607c071747b83361f878e00bf4e))

## [2.2.1](https://github.com/rancher/terraform-aws-access/compare/v2.2.0...v2.2.1) (2024-05-31)


### Bug Fixes

* add and use address block for network ([#79](https://github.com/rancher/terraform-aws-access/issues/79)) ([0bb30b9](https://github.com/rancher/terraform-aws-access/commit/0bb30b966eccd8deb593087408f0df90f932273e))
* add notes for latest release ([#78](https://github.com/rancher/terraform-aws-access/issues/78)) ([e6c4380](https://github.com/rancher/terraform-aws-access/commit/e6c4380759ea185b5995f4c6f1aa7afab174f387))
* add private address ([#76](https://github.com/rancher/terraform-aws-access/issues/76)) ([6bb4328](https://github.com/rancher/terraform-aws-access/commit/6bb4328c5cf232d3b22f3e0489bb86a53fd2888b))

## [2.2.0](https://github.com/rancher/terraform-aws-access/compare/v2.1.3...v2.2.0) (2024-05-13)


### Features

* certificate controls ([#73](https://github.com/rancher/terraform-aws-access/issues/73)) ([35e62ca](https://github.com/rancher/terraform-aws-access/commit/35e62ca5998cd72ae5c1f24c04fcb6ffaae847c9))


### Bug Fixes

* update recent changes ([#75](https://github.com/rancher/terraform-aws-access/issues/75)) ([73495f2](https://github.com/rancher/terraform-aws-access/commit/73495f29ffd42ddf0377c52b1c7621974645e473))

## [2.1.3](https://github.com/rancher/terraform-aws-access/compare/v2.1.2...v2.1.3) (2024-05-03)


### Bug Fixes

* make subnet names static ([#71](https://github.com/rancher/terraform-aws-access/issues/71)) ([b256b55](https://github.com/rancher/terraform-aws-access/commit/b256b55fb6c3d262637f559fb097558c285f2b67))

## [2.1.2](https://github.com/rancher/terraform-aws-access/compare/v2.1.1...v2.1.2) (2024-05-03)


### Bug Fixes

* add more random names ([#70](https://github.com/rancher/terraform-aws-access/issues/70)) ([403f630](https://github.com/rancher/terraform-aws-access/commit/403f6309ef5f03b5f3530c0c6af01c250f7e270a))
* minor fix and nix ([#68](https://github.com/rancher/terraform-aws-access/issues/68)) ([261177a](https://github.com/rancher/terraform-aws-access/commit/261177ad4c102b6787facc3333037099528ad8ba))

## [2.1.1](https://github.com/rancher/terraform-aws-access/compare/v2.1.0...v2.1.1) (2024-04-18)


### Bug Fixes

* add target group output ([#66](https://github.com/rancher/terraform-aws-access/issues/66)) ([ec834f2](https://github.com/rancher/terraform-aws-access/commit/ec834f2db1245640ee0c4cdddab59ec7558c5b5b))

## [2.1.0](https://github.com/rancher/terraform-aws-access/compare/v2.0.0...v2.1.0) (2024-04-18)


### Features

* adding listeners and targets ([#53](https://github.com/rancher/terraform-aws-access/issues/53)) ([de2f8f0](https://github.com/rancher/terraform-aws-access/commit/de2f8f041d9026200b4bc51ac35b1396a85050d7))


### Bug Fixes

* add logging to leftovers ([#58](https://github.com/rancher/terraform-aws-access/issues/58)) ([10c947e](https://github.com/rancher/terraform-aws-access/commit/10c947e92cc6c6ed3e86122c3db0f5e13e9f8a5f))
* add zone to keep variables ([#56](https://github.com/rancher/terraform-aws-access/issues/56)) ([1fb1460](https://github.com/rancher/terraform-aws-access/commit/1fb1460d35086760c85c0d81957dea0f0eaf0bf5))
* add zone to release environment ([#55](https://github.com/rancher/terraform-aws-access/issues/55)) ([f0de2b1](https://github.com/rancher/terraform-aws-access/commit/f0de2b115bd883f00ee027a8fde7bac675e2f761))
* added address policy ([#64](https://github.com/rancher/terraform-aws-access/issues/64)) ([7dff0e3](https://github.com/rancher/terraform-aws-access/commit/7dff0e3793b2e61d28e366b7a83a4678c63cea27))
* adding more logging ([#62](https://github.com/rancher/terraform-aws-access/issues/62)) ([9ab4179](https://github.com/rancher/terraform-aws-access/commit/9ab417928daee16be9fc2721b6122b05521455b6))
* adding notes about leftovers ([#65](https://github.com/rancher/terraform-aws-access/issues/65)) ([f997479](https://github.com/rancher/terraform-aws-access/commit/f9974795c8371c36893f490c67c4ae46cf018587))
* also filter 404 and unauthorized ([#60](https://github.com/rancher/terraform-aws-access/issues/60)) ([e393cf4](https://github.com/rancher/terraform-aws-access/commit/e393cf40eadb00f7fd00eaff1b1c83f5f91cd7d3))
* call leftovers before test ([#57](https://github.com/rancher/terraform-aws-access/issues/57)) ([42832e3](https://github.com/rancher/terraform-aws-access/commit/42832e37c6f7605c5c5bab17d260798c5cf2ab43))
* filter access denied errors ([#59](https://github.com/rancher/terraform-aws-access/issues/59)) ([3fdbbf7](https://github.com/rancher/terraform-aws-access/commit/3fdbbf766224e5f13e8378adc5ae77b886f73b3a))
* filter all 400 status codes ([#61](https://github.com/rancher/terraform-aws-access/issues/61)) ([f29e8b8](https://github.com/rancher/terraform-aws-access/commit/f29e8b870ca7ecc495bf55b77b4d6dce77d57f59))
* resolve weird exit problems ([#63](https://github.com/rancher/terraform-aws-access/issues/63)) ([80f1d06](https://github.com/rancher/terraform-aws-access/commit/80f1d06898549f4c324c51c8d8301a6e864c9414))

## [2.0.0](https://github.com/rancher/terraform-aws-access/compare/v1.2.0...v2.0.0) (2024-04-06)


### ⚠ BREAKING CHANGES

* add domains and load balancing ([#42](https://github.com/rancher/terraform-aws-access/issues/42))

### Bug Fixes

* add encrypt address everywhere ([#45](https://github.com/rancher/terraform-aws-access/issues/45)) ([962c133](https://github.com/rancher/terraform-aws-access/commit/962c1333c8f70c7183f46eafa7f1e134d99f9f81))
* add encrypt address everywhere ([#46](https://github.com/rancher/terraform-aws-access/issues/46)) ([6e8ddd0](https://github.com/rancher/terraform-aws-access/commit/6e8ddd04601e8dd5f4cf96ff3d9b421e4606dce8))
* add notes on policies ([#48](https://github.com/rancher/terraform-aws-access/issues/48)) ([559c579](https://github.com/rancher/terraform-aws-access/commit/559c57904a90060a7f21fe765ad19acfa63775b1))
* add policies and reduce speed ([#49](https://github.com/rancher/terraform-aws-access/issues/49)) ([daef0d8](https://github.com/rancher/terraform-aws-access/commit/daef0d888eb6421691fd9108193d290504dcd07b))
* add policy and speed up ([#51](https://github.com/rancher/terraform-aws-access/issues/51)) ([9b964a9](https://github.com/rancher/terraform-aws-access/commit/9b964a9b9aa1fa688eb4a453c056669e4a750eb2))
* add tag policy ([#52](https://github.com/rancher/terraform-aws-access/issues/52)) ([a6bf9c5](https://github.com/rancher/terraform-aws-access/commit/a6bf9c5eebb3879614bb8a592f83b161bed05b53))
* keep the domain variable ([#44](https://github.com/rancher/terraform-aws-access/issues/44)) ([148b48a](https://github.com/rancher/terraform-aws-access/commit/148b48ae34990faf9c8373e396602c1b31a03067))
* requested more elastic addresses ([#50](https://github.com/rancher/terraform-aws-access/issues/50)) ([ad3e046](https://github.com/rancher/terraform-aws-access/commit/ad3e046b830582a69878ec92fb3ae88ca3b591ef))
* resolve ingress to balanced ports ([#43](https://github.com/rancher/terraform-aws-access/issues/43)) ([de2a8fa](https://github.com/rancher/terraform-aws-access/commit/de2a8fa165aa6399ee3b08a45f44a3e69fd21e42))
* update notes on ingress ([#47](https://github.com/rancher/terraform-aws-access/issues/47)) ([2046845](https://github.com/rancher/terraform-aws-access/commit/2046845025c60d74c35cb706b20507ea94187ada))
* update workflows to meet new standards ([#40](https://github.com/rancher/terraform-aws-access/issues/40)) ([4933b3a](https://github.com/rancher/terraform-aws-access/commit/4933b3a09ee46d69c1ed5c22a5b822d64fa740cf))


### Code Refactoring

* add domains and load balancing ([#42](https://github.com/rancher/terraform-aws-access/issues/42)) ([6cb3cff](https://github.com/rancher/terraform-aws-access/commit/6cb3cff557a9bb5b8a1aadd3a619ade9603f1d65))

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
