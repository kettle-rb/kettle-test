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

- Retemplated project metadata and development tooling for `kettle-dev` 2.2.1
  and `yard-fence` 0.9.3.

### Deprecated

### Removed

### Fixed

- Updated generated project metadata links to use the migrated `kettle-dev`
  GitHub organization.

- Restored `docs/CNAME` so the generated documentation site keeps its custom domain.

### Security

## [2.0.4] - 2026-06-08

- TAG: [v2.0.4][2.0.4t]
- COVERAGE: 100.00% -- 91/91 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 90.00% documented

### Changed

- Retemplated project workflows with the current kettle-jem template and raised
  the runtime `turbo_tests2` dependency floor to v3.1.2.

### Fixed

- `kettle-test` now configures RSpec random ordering so run highlights include
  the randomization seed needed to reproduce order-dependent failures.

## [2.0.3] - 2026-06-02

- TAG: [v2.0.3][2.0.3t]
- COVERAGE: 100.00% -- 91/91 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 90.00% documented

### Changed

- Retemplated project files with the current kettle-jem template, including
  refreshed coverage and style dependency floors.
- Updated the runtime `turbo_tests2` dependency to require v3.1.1 or newer.
- Updated to latest versions of other dependencies

### Fixed

- Made the ENV-driven configuration spec explicitly remove nil-valued child
  process overrides so JRuby 9.2 does not inherit `KETTLE_TEST_SILENT=false`.

## [2.0.2] - 2026-06-01

- TAG: [v2.0.2][2.0.2t]
- COVERAGE: 100.00% -- 91/91 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 90.00% documented

### Changed

- Retemplated project files with the current kettle-jem template, including the
  StructuredMerge config migration, generated workflow updates, README logo
  refresh, and updated development dependency floors.
- Updated the runtime `turbo_tests2` dependency to require v3.1.0 or newer.

### Fixed

- `kettle-test` now resolves Appraisal gemfiles under `gemfiles/` back to the
  project root before running specs, so coverage and log artifacts stay under
  root-level `coverage/` and `tmp/` instead of being written inside `gemfiles/`.

## [2.0.1] - 2026-05-25

- TAG: [v2.0.1][2.0.1t]
- COVERAGE: 100.00% -- 91/91 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 90.00% documented

### Changed

- Refreshed generated project templates and CI workflows.
- Refreshed project templating and generated documentation after the 2.0.0
  release.
- Pruned generated binstubs to the current curated kettle-jem set.
- Updated local modular Gemfile sibling wiring for coverage, documentation, and templating.
- Updated the coverage bundle to require `kettle-soup-cover` 1.1.3 or newer.

### Fixed

- `kettle-test` now invokes `kettle-soup-cover`'s turbo coverage setup and
  cleanup APIs directly around the default `turbo_tests2` runner, so collated
  coverage artifacts are published even when the host Rakefile does not load the
  optional turbo coverage rake tasks.
- `kettle-test --help` now prints usage and exits without creating
  `tmp/kettle-test` logs or invoking the configured test runner.

## [2.0.0] - 2026-05-23

- TAG: [v2.0.0][2.0.0t]
- COVERAGE: 100.00% -- 91/91 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 90.00% documented

### Added

- Added the `kettle-test` executable, which runs RSpec through Bundler, captures
  full output under `tmp/kettle-test/`, and prints a compact failure, seed,
  timing, and coverage summary.
- Added default `kettle/test/rspec` integration coverage for exported RSpec
  helpers and configuration constants.

### Changed

- `kettle-test` now runs specs through `turbo_tests2` by default, with
  `KETTLE_TEST_RUNNER=rspec` available as an opt-out for direct RSpec runs.
- Added `KETTLE_TEST_TURBO_PROCESSES`, `KETTLE_TEST_TURBO_RUNTIME_LOG`, and
  `KETTLE_TEST_TURBO_NICE` controls for the default `turbo_tests2` runner.
- Switched the coverage test stack to `turbo_tests2 ~> 3.0`.
- Migrated local development dependency wiring to the current nomono-based
  modular Gemfile pattern used by the kettle-rb template.
- Refreshed project templating, CI workflows, and release support files from the
  current kettle-jem full template.
- Changed the project license metadata and generated license files to
  `AGPL-3.0-only`.
- Dropped support for Ruby 2.3 because `turbo_tests2` is now a runtime
  dependency and requires Ruby 2.4 or newer.

## [1.0.10] - 2026-02-06

- TAG: [v1.0.10][1.0.10t]
- COVERAGE: 100.00% -- 86/86 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 100.00% documented

### Changed

- Upgraded to [appraisal2 v3.0.1](https://github.com/appraisal-rb/appraisal2/releases/tag/v3.0.1)

### Fixed

- removed redundant development dependencies

## [1.0.9] - 2026-02-06

- TAG: [v1.0.9][1.0.9t]
- COVERAGE: 100.00% -- 86/86 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 100.00% documented

### Added

- Document usage of rspec-pending_for

## [1.0.8] - 2026-02-06

- TAG: [v1.0.8][1.0.8t]
- COVERAGE: 100.00% -- 86/86 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 100.00% documented

### Added

- rspec/pending_for made available by default
  - `skip_for` and `pending_for` are now available by default, without needing to explicitly require 'rspec/pending_for'

### Changed

- Updated documentation on hostile takeover of RubyGems
  - https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo

## [1.0.7] - 2025-12-06

- TAG: [v1.0.7][1.0.7t]
- COVERAGE: 100.00% -- 84/84 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 100.00% documented

### Added

- traditional `Kettle::Test::VERSION` constant
- make `hide_env` (from rspec-stubbed_env) available by default
- increased documentation to 100%, and added many documentation improvements

## [1.0.6] - 2025-10-21

- TAG: [v1.0.6][1.0.6t]
- COVERAGE: 100.00% -- 83/83 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 94.44% documented

### Added

- more complete usage documentation

### Fixed

- completed change of backports to runtime dependency

## [1.0.5] - 2025-10-20

- TAG: [v1.0.5][1.0.5t]
- COVERAGE: 100.00% -- 83/83 lines in 15 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 15 files
- 94.44% documented

### Added

- runtime dependency on rspec-pending_for

## [1.0.4] - 2025-10-20

- TAG: [v1.0.4][1.0.4t]
- COVERAGE: 100.00% -- 81/81 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented

### Added

- dependency on backports for Ruby 2.3 & 2.4 support
- default config for rspec-pending_for

### Changed

- upgraded kettle-dev to 1.1.34 for development

## [1.0.3] - 2025-08-29

- TAG: [v1.0.3][1.0.3t]
- COVERAGE: 100.00% -- 81/81 lines in 13 files
- BRANCH COVERAGE: 100.00% -- 2/2 branches in 13 files
- 94.44% documented

### Added

- improved documentation in README.md
- opencollective funding links to README.md

### Changed

- kettle-dev 1.0.18 for development

### Removed

- invalid checksums for old releases

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

[Unreleased]: https://github.com/kettle-rb/kettle-test/compare/v2.0.4...HEAD
[2.0.4]: https://github.com/kettle-rb/kettle-test/compare/v2.0.3...v2.0.4
[2.0.4t]: https://github.com/kettle-rb/kettle-test/releases/tag/v2.0.4
[2.0.3]: https://github.com/kettle-rb/kettle-test/compare/v2.0.2...v2.0.3
[2.0.3t]: https://github.com/kettle-rb/kettle-test/releases/tag/v2.0.3
[2.0.2]: https://github.com/kettle-rb/kettle-test/compare/v2.0.1...v2.0.2
[2.0.2t]: https://github.com/kettle-rb/kettle-test/releases/tag/v2.0.2
[2.0.1]: https://github.com/kettle-rb/kettle-test/compare/v2.0.0...v2.0.1
[2.0.1t]: https://github.com/kettle-rb/kettle-test/releases/tag/v2.0.1
[2.0.0]: https://github.com/kettle-rb/kettle-test/compare/v1.0.10...v2.0.0
[2.0.0t]: https://github.com/kettle-rb/kettle-test/releases/tag/v2.0.0
[1.0.10]: https://github.com/kettle-rb/kettle-test/compare/v1.0.9...v1.0.10
[1.0.10t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.10
[1.0.9]: https://github.com/kettle-rb/kettle-test/compare/v1.0.8...v1.0.9
[1.0.9t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.9
[1.0.8]: https://github.com/kettle-rb/kettle-test/compare/v1.0.7...v1.0.8
[1.0.8t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.8
[1.0.7]: https://github.com/kettle-rb/kettle-test/compare/v1.0.6...v1.0.7
[1.0.7t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.7
[1.0.6]: https://github.com/kettle-rb/kettle-test/compare/v1.0.5...v1.0.6
[1.0.6t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.6
[1.0.5]: https://github.com/kettle-rb/kettle-test/compare/v1.0.4...v1.0.5
[1.0.5t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.5
[1.0.4]: https://github.com/kettle-rb/kettle-test/compare/v1.0.3...v1.0.4
[1.0.4t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.4
[1.0.3]: https://github.com/kettle-rb/kettle-test/compare/v1.0.2...v1.0.3
[1.0.3t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.3
[1.0.2]: https://github.com/kettle-rb/kettle-test/compare/v1.0.1...v1.0.2
[1.0.2t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.2
[1.0.1]: https://github.com/kettle-rb/kettle-test/compare/v1.0.0...v1.0.1
[1.0.1t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.1
[1.0.0]: https://github.com/kettle-rb/kettle-test/compare/baed02cf1ca1e0e8c75c11fd188edaf1a4f5f08b...v1.0.0
[1.0.0t]: https://github.com/kettle-rb/kettle-test/releases/tag/v1.0.0
