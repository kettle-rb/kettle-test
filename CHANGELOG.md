# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [1.0.2] - 2025-08-29
- TAG: [v1.0.2][1.0.2t]
- COVERAGE: 100.00% -- 81/81 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented
### Removed
- checksums from packaged gem
### Fixed
- gem packaged without checksums
  - can't be in the packaged gem, since they would change the checksum of the gem itself
### Security
- corrected checksums for the next release (not packaged, only tracked in VCS)

## [1.0.1] - 2025-08-29
- TAG: [v1.0.1][1.0.1t]
- COVERAGE: 100.00% -- 81/81 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented
### Added
- RSpec shared context: "with rake"
### Fixed
- Typos in README.md
- Typos in CHANGELOG.md

## [1.0.0] - 2025-08-22
- TAG: [v1.0.0][1.0.0t]
- COVERAGE: 100.00% -- 69/69 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented
### Added
- initial release, with auto-config support for:
  - rspec
  - rspec-block_is_expected
  - rspec-stubbed_env
  - silent_stream
  - timecop-rspec

[Unreleased]: https://github.com/kettle-rb/kettle-test/compare/v1.0.2...HEAD
[1.0.0]: https://github.com/kettle-rb/kettle-test/compare/baed02cf1ca1e0e8c75c11fd188edaf1a4f5f08b...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.0
[1.0.1]: https://github.com/kettle-rb/kettle-test/compare/v1.0.0...v1.0.1
[1.0.1t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.1
[1.0.2]: https://github.com/kettle-rb/kettle-test/compare/v1.0.1...v1.0.2
[1.0.2t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.2
