Project: kettle-test — Development Guidelines (for advanced contributors)

This document captures project-specific knowledge to streamline setup, testing, and ongoing development.

1. Build and configuration
- ENV is controlled by `direnv`.
  - Two files are loaded:
    - .envrc — environment variables for local development, committed to source control
    - .env.local — environment variables that are not committed to source control. These setting override .envrc.
  - Run `direnv allow` after making changes to .envrc or .env.local.
    - See .envrc for details.
    - See .env.local.example for an example of what to put in .env.local.
    - See CONTRIBUTING.md for details on how to set up your local environment.
- Ruby and Bundler
  - Runtime supports very old Rubies (>= 1.9.2) but development tooling targets >= 2.3 because of CI/setup-ruby and dev dependencies.
  - Use a recent Ruby (>= 3.1 recommended) for fastest setup and to exercise modern coverage behavior.
  - Install dependencies via Bundler in project root:
    - bundle install
- Rake tasks (preferred entry points)
  - The Rakefile wires common workflows. Useful targets:
    - rake spec — run RSpec suite (also aliased via rake test)
    - rake coverage — run specs with coverage locally and open a report (requires kettle-soup-cover)
    - rake rubocop_gradual:autocorrect — RuboCop-LTS Gradual, with autocorrect as default task
    - rake reek and rake reek:update — code smell checks and persisted snapshots in REEK
    - rake yard — generate YARD docs for lib and selected extra files
    - rake bundle:audit and rake bundle:audit:update — dependency vulnerability checks
    - rake build / rake release — gem build/release helper tasks (Bundler + stone_checksums)
  - The default rake target runs a curated set of tasks; this varies for CI vs local (see CI env var logic in Rakefile).
    - Always run the default rake task prior commits, and after making changes to lib/ code, or *.md files, to allow the linter to autocorrect, and to generate updated documentation.
- Coverage orchestration
  - Coverage is controlled by kettle-soup-cover and .simplecov. Thresholds (line and branch) are enforced and can fail the process.
  - Thresholds are primarily controlled by environment variables (see .simplecov and comments therein) typically loaded via direnv (.envrc) and CI workflow (.github/workflows/coverage.yml). When running only a test subset, thresholds may fail; see Testing below.
- Gem signing (for releases)
  - Signing is enabled unless SKIP_GEM_SIGNING is set. If enabled and certificates are present (certs/<USER>.pem), gem build will attempt to sign using ~/.ssh/gem-private_key.pem.
  - See CONTRIBUTING.md for releasing details; use SKIP_GEM_SIGNING when building in environments without the private key.

2. Testing
- Framework and helpers
  - RSpec 3.13 with custom spec/spec_helper.rb configuration:
    - silent_stream: STDOUT is silenced by default for examples to keep logs clean.
      - To explicitly test console output, tag the example or group with :check_output.
    - Global state hygiene: Around each example, FlossFunding.namespaces and FlossFunding.silenced are snapshotted and restored to prevent cross-test pollution.
    - DEBUG toggle: Set DEBUG=true to require 'debug' and avoid silencing output during your run.
    - ENV seeding: The suite sets ENV["FLOSS_FUNDING_FLOSS_FUNDING"] = "Free-as-in-beer" so that the library’s own namespace is considered activated (avoids noisy warnings).
    - Coverage: kettle-soup-cover integrates SimpleCov; .simplecov is invoked from spec_helper when enabled by Kettle::Soup::Cover::DO_COV, which is controlled by K_SOUP_COV_DO being set to true / false.
    - RSpec.describe usage:
      - Use `describe "#<method_name>"` to contain a block of specs that test instance method behavior.
      - Use `describe "::<method_name>"` to contain a block of specs that test class method behavior.
      - Do not use `describe ".<method_name>"` because the dot is ambiguous w.r.t instance vs. class methods. 
    - When adding new code or modifying existing code always add tests to cover the updated behavior, including branches, and different types of expected and unexpected inputs.
  - Additional test utilities:
    - rspec-stubbed_env: Use stub_env to control ENV safely within examples.
    - timecop-rspec: Time manipulation available, see lib/kettle/test/config/int/rspec/timecop_rspec.
- Running tests (verified)
  - Full suite (recommended to satisfy coverage thresholds):
    - bin/rspec
    - or: bundle exec rspec
    - or: bundle exec rake spec
  - Progress format (less verbose):
    - bundle exec rspec --format progress
  - Focused runs
    - You can run a single file or example, but note: coverage thresholds need to be disabled with K_SOUP_COV_MIN_HARD=false
    - Example: K_SOUP_COV_MIN_HARD=false bin/rspec spec/kettle-test/class_spec.rb:42
  - Output visibility
    - To see STDOUT from the code under test, use the :check_output tag on the example or group.
      Example:
      RSpec.describe "output", :check_output do
        it "prints" do
          puts "This output should be visible"
          expect(true).to be true
        end
      end
    - Alternatively, run with DEBUG=true to disable silencing for the entire run.
  - During a spec run, the presence of output about missing activation keys is often expected, since it is literally what this library is for. It only indicates a failure if the spec expected all activation keys to be present, and not all specs do.
- Adding new tests (guidelines)
  - Organize specs by class/module. Do not create per-task umbrella spec files; add examples to the existing spec for the class/module under test, or create a new spec file for that class/module if one does not exist. Only create a standalone scenario spec when it intentionally spans multiple classes for an integration/benchmark scenario (e.g., bench_integration_spec), and name it accordingly.
  - Add tests for all public methods and add contexts for variations of their arguments, and arity.
  - This repository targets near-100% coverage of Kettle::Test public API and RSpec-integrations (silent_stream, timecop, stubbed_env); when you add new public methods or config behavior, add or update specs accordingly.
  - Place new specs under spec/ mirroring lib/ structure where possible. Do not require "spec_helper" at the top of spec files, as it is automatically loaded by .rspec.
  - If your code relies on environment variables that drive activation (see "Activation env vars" below), prefer using rspec-stubbed_env:
    - it does not support stubbing with blocks, but it does automatically clean up after itself.
    - outside the example:
      include_context 'with stubbed env'
    - in a before hook, or in an example:
      stub_env("FLOSS_FUNDING_MY_NS" => "Free-as-in-beer")
      # example code continues
  - If your spec needs to assert on console output, tag it with :check_output. By default, STDOUT is silenced.
  - Use Timecop for deterministic time-sensitive behavior as needed (require config/timecop is already done by spec_helper).
- Demonstrated example (executed and verified during this session)
  - Example spec content used:
    - File: spec/kettle-test/demo_spec.rb
      RSpec.describe "Demo test for guidelines" do
        it "has a non-empty version string" do
          expect(FlossFunding::Version::VERSION).to be_a(String)
          expect(FlossFunding::Version::VERSION).not_to be_empty
        end
      end
  - Commands run:
    - bundle exec rspec spec/kettle-test/demo_spec.rb — this ran but failed coverage thresholds (expected when running subsets with coverage on).
    - bundle exec rspec — running the full suite including the demo spec passed; overall coverage: ~93.67% lines, ~74.07% branches.
  - Cleanup: The demo spec file was removed after verification per instructions.

3. Additional development information
- Activation env vars and namespacing (important for tests and local runs)
  - The library behavior is driven by namespace-based activation keys: ENV["FLOSS_FUNDING_<NAMESPACE>"].
  - The FlossFunding::Namespace class derives env var names via FlossFunding::UnderBar.env_variable_name(name). Recognized activation forms include:
    - Free-as-in-beer, Business-is-not-good-yet, or NOT-FINANCIALLY-SUPPORTING-<namespace> — treated as unpaid/opted-out and considered "activated" for silent success (no console warnings).
    - A paid activation key is a 64-char hex string; it is decrypted with AES-256-CBC using a key derived from Digest::MD5.hexdigest(namespace).
  - In tests, avoid noisy output and unrelated failures by either using the provided default (ENV seeded for this gem) or stubbing the relevant ENV vars for the namespaces you trigger.
- Code style and static analysis
  - RuboCop-LTS (Gradual) is integrated. Use:
    - bundle exec rake rubocop_gradual:autocorrect
    - bundle exec rake rubocop_gradual:force_update # only run if there are still linting violations the default rake task, which includes autocorrect locally, or a standalone autocorrect task, has run, and failed, and the violations won't be fixed
  - Reek is configured to scan {lib,spec,tests}/**/*.rb. Use:
    - bundle exec rake reek
    - bundle exec rake reek:update              # writes current output to REEK, fails on smells
    - Keep REEK file updated with intentional smells snapshot when appropriate (e.g., after refactors).
    - Locally, the default rake task includes reek:update.
- Documentation
  - Generate YARD docs with: bundle exec rake yard. It includes lib/**/*.rb and extra docs like README.md, CHANGELOG.md, RUBOCOP.md, REEK, etc.
- Appraisal and multi-gemfile testing
  - appraisal2 is present to manage multiple dependency sets; see Appraisals and gemfiles/modular/*.gemfile. If you need to verify against alternate dependency versions, use Appraisal to install and run rspec under those Gemfiles.
  - You can run a single github workflow by running `act -W /github/workflows/<workflow name>.yml`
- CI/local differences and defaults
  - The Rakefile adjusts default tasks based on CI env var. Locally, rake default may include coverage, reek:update, yard, etc. On CI, it tends to just run spec.

Quick start
1) bundle install
2) K_SOUP_COV_FORMATTERS="xml,rcov,lcov,json" bin/rspec (generates coverage reports in coverage/ in the specified formats, only choose the formats you need)
3) Optional local HTML coverage report: K_SOUP_COV_FORMATTERS="html" bin/rspec (generates HTML coverage report in coverage/ - but this is too verbose for AI, so Junie should use one of the more terse formats, like rcov, lcov, or json)
4) Static analysis: bundle exec rake rubocop_gradual:check && bundle exec rake reek

Notes
- ALWAYS Run bundle exec rake rubocop_gradual:autocorrect as the final step before completing a task, to lint and autocorrect any remaining issues. Then if there are new lint failures, attempt to correct them manually.
- NEVER run vanilla rubocop, as it won't handle the linting config properly. Always run rubocop_gradual:autocorrect or rubocop_gradual.
- NEVER consider backwards compatibility when adding new features or refactoring existing code, as this library is in the design phase, and is still an alpha release.
- Running only a subset of specs is supported but in order to bypass the hard failure due to coverage thresholds, you need to run with K_SOUP_COV_MIN_HARD=false.
- When adding code that writes to STDOUT, remember most specs silence output unless tagged with :check_output or DEBUG=true.
- For all the kettle-soup-cover options, see .envrc and find the K_SOUP_COV_* env vars.
