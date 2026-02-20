# AGENTS.md - kettle-test Development Guide

## 🎯 Project Overview

`kettle-test` is a **meta tool from kettle-rb to streamline testing** of RubyGem projects. It acts as a shim dependency, pulling in many testing dependencies, and configures RSpec with syntactic sugar to make writing tests easier. It provides environment variable helpers, output silencing, time manipulation, and CI-aware configuration — all pre-wired and ready to go.

**Core Philosophy**: Every kettle-rb gem uses `kettle-test` for test infrastructure. It should never need per-project configuration beyond `require "kettle/test/rspec"`.

**Repository**: https://github.com/kettle-rb/kettle-test
**Current Version**: 1.0.10
**Required Ruby**: >= 2.3.0 (currently developed against Ruby 4.0.1)

## ⚠️ AI Agent Terminal Limitations

### Terminal Output Is Not Visible

**CRITICAL**: AI agents using `run_in_terminal` almost never see the command output. The terminal tool sends commands to a persistent Copilot terminal, but output is frequently lost or invisible to the agent.

**Workaround**: Always redirect output to a file in the project's local `tmp/` directory, then read it back:

```bash
bundle exec rspec spec/some_spec.rb > tmp/test_output.txt 2>&1
```
Then use `read_file` to see `tmp/test_output.txt`.

**NEVER** use `/tmp` or other system directories — always use the project's own `tmp/` directory.

### direnv Requires Separate `cd` Command

**CRITICAL**: The project uses `direnv` to load environment variables from `.envrc`. When you `cd` into the project directory, `direnv` initializes **after** the shell prompt returns. If you chain `cd` with other commands via `&&`, the subsequent commands run **before** `direnv` has loaded the environment.

✅ **CORRECT** — Run `cd` alone, then run commands separately:
```bash
cd /home/pboling/src/kettle-rb/ast-merge/vendor/kettle-test
```
```bash
bundle exec rspec
```

❌ **WRONG** — Never chain `cd` with `&&`:
```bash
cd /home/pboling/src/kettle-rb/ast-merge/vendor/kettle-test && bundle exec rspec
```

### Prefer Internal Tools Over Terminal

✅ **PREFERRED** — Use internal tools:
- `grep_search` instead of `grep` command
- `file_search` instead of `find` command
- `read_file` instead of `cat` command
- `list_dir` instead of `ls` command
- `replace_string_in_file` or `create_file` instead of `sed` / manual editing

❌ **AVOID** when possible:
- `run_in_terminal` for information gathering

Only use terminal for:
- Running tests (`bundle exec rspec`)
- Installing dependencies (`bundle install`)
- Git operations that require interaction
- Commands that actually need to execute (not just gather info)

### NEVER Pipe Test Commands Through head/tail

❌ **ABSOLUTELY FORBIDDEN**:
```bash
bundle exec rspec 2>&1 | tail -50
```

✅ **CORRECT** — Redirect to file:
```bash
bundle exec rspec > tmp/test_output.txt 2>&1
```

## 🏗️ Architecture

### What kettle-test Provides

All of these are **runtime dependencies** (not dev dependencies), because this gem's purpose is to be a test-time dependency for other gems.

- **`Kettle::Test`** — Main module with environment-controlled constants
- **RSpec Configuration** — Pre-configured RSpec with output silencing, profiling, CI filters
- **Environment Variable Helpers** — `stub_env` and `hide_env` (from `rspec-stubbed_env`)
- **Block Expectations** — `block_is_expected` (from `rspec-block_is_expected`)
- **Output Capture** — `capture` helper (from `silent_stream`)
- **Time Manipulation** — Timecop integration with sequential time machine mode (from `timecop-rspec`)
- **Pending Specs** — Ruby-version-aware spec skipping (from `rspec-pending_for`)

### Key Constants

| Constant | Default | Purpose |
|----------|---------|---------|
| `Kettle::Test::DEBUG` | `false` | Disables output silencing when true |
| `Kettle::Test::IS_CI` | from `CI` env | Detects CI environment |
| `Kettle::Test::SILENT` | matches `IS_CI` | Controls output silencing |
| `Kettle::Test::FULL_BACKTRACE` | `false` | Enables full RSpec backtraces |
| `Kettle::Test::RSPEC_PROFILE_EXAMPLES` | `false` | Enables example profiling |
| `Kettle::Test::GLOBAL_DATE` | `Date.today` | Baseline date for Timecop |
| `Kettle::Test::TIME_MACHINE_SEQUENTIAL` | `true` | Sequential time machine mode |

### Runtime Dependencies

| Gem | Role |
|-----|------|
| `rspec` (~> 3.0) | Test framework |
| `rspec-block_is_expected` (~> 1.0) | Block expectation syntax |
| `rspec_junit_formatter` (~> 0.6) | JUnit XML output for CI |
| `rspec-pending_for` (~> 0.1) | Ruby-version-aware pending |
| `rspec-stubbed_env` (~> 1.0) | ENV stubbing helpers |
| `silent_stream` (~> 1.0) | Output capture/silencing |
| `timecop-rspec` (~> 1.0) | Time manipulation |
| `appraisal2` (~> 3.0) | Multi-dependency testing |
| `backports` (~> 3.0) | Ruby backports |
| `version_gem` (~> 1.1) | Version management |

### Vendor Directory

**IMPORTANT**: This project lives in `vendor/kettle-test/` within the `ast-merge` workspace. It is a **nested git project** with its own `.git/` directory. The `grep_search` tool **CANNOT search inside nested git projects** — use `read_file` and `list_dir` instead.

## 📁 Project Structure

```
lib/kettle/
├── test.rb                        # Main module, constants, parallel detection
└── test/
    ├── config/
    │   ├── ext/                   # External gem configuration
    │   │   ├── backports.rb       # Backports setup
    │   │   ├── rspec/             # RSpec configuration directory
    │   │   └── timecop.rb         # Timecop configuration
    │   ├── int/                   # Internal RSpec integration
    │   │   ├── rspec/
    │   │   │   ├── rspec_core.rb  # Core RSpec configuration
    │   │   │   ├── silent_stream.rb # Output silencing around examples
    │   │   │   └── timecop_rspec.rb # Timecop integration for specs
    │   │   ├── rspec_block_is_expected.rb
    │   │   └── rspec_pending_for.rb
    │   └── version_gem.rb         # version_gem integration
    ├── external.rb                # External dependency loader
    ├── internal.rb                # Internal configuration loader
    ├── mocks/
    │   └── test_task.rake         # Mock rake task for testing
    ├── rspec.rb                   # Main RSpec entry point (require this!)
    ├── support/
    │   └── shared_contexts/       # Shared RSpec contexts
    └── version.rb                 # Version constant
```

## 🔧 Development Workflows

### Running Tests

```bash
cd /home/pboling/src/kettle-rb/ast-merge/vendor/kettle-test
```
```bash
bundle exec rspec > tmp/test_output.txt 2>&1
```

### Coverage Reports

```bash
cd /home/pboling/src/kettle-rb/ast-merge/vendor/kettle-test
```
```bash
bin/rake coverage > tmp/coverage_output.txt 2>&1
```

**Key ENV variables** (set in `.envrc`):
- `K_SOUP_COV_DO=true` – Enable coverage
- `K_SOUP_COV_MIN_LINE=100` – Line coverage threshold (100%!)
- `K_SOUP_COV_MIN_BRANCH=100` – Branch coverage threshold (100%!)
- `K_SOUP_COV_MIN_HARD=true` – Fail if thresholds not met

## 📝 Usage in Other Gems

### Loading in spec_helper.rb

```ruby
# In any kettle-rb gem's spec/spec_helper.rb:
require "kettle/test/rspec"
```

This single require loads everything: RSpec configuration, stubbed_env, silent_stream, timecop, block_is_expected, pending_for, and all other helpers.

### Environment Variable Helpers

```ruby
# Stub environment variables (not used with blocks)
before do
  stub_env("MY_ENV_VAR" => "value")
end
it "reads the env" do
  expect(ENV["MY_ENV_VAR"]).to eq("value")
end

# Hide environment variables
before do
  hide_env("HOME", "USER")
end
it "hides the env" do
  expect(ENV["HOME"]).to be_nil
end
```

### Block Expectations

```ruby
subject { -> { raise "boom" } }
it "raises" do
  block_is_expected.to raise_error("boom")
end
```

### Output Silencing

By default, STDOUT/STDERR are silenced during specs (controlled by `KETTLE_TEST_SILENT`). Specs tagged with `:check_output` bypass silencing. Debug mode (`KETTLE_TEST_DEBUG=true`) also disables silencing.

### Timecop Integration

Tests automatically have time frozen to `GLOBAL_DATE` (defaults to today). Sequential time machine mode advances time slightly between examples to avoid timestamp collisions.

## 🔍 Critical Files

| File | Purpose |
|------|---------|
| `lib/kettle/test/rspec.rb` | Main RSpec entry point — load this in spec_helper |
| `lib/kettle/test.rb` | Constants and parallel detection |
| `lib/kettle/test/external.rb` | External dependency loader |
| `lib/kettle/test/internal.rb` | Internal RSpec config loader |
| `lib/kettle/test/config/int/rspec/silent_stream.rb` | Output silencing around examples |
| `lib/kettle/test/config/int/rspec/timecop_rspec.rb` | Timecop freeze/travel integration |
| `lib/kettle/test/config/int/rspec/rspec_core.rb` | Core RSpec settings |

## 🚫 Common Pitfalls

1. **NEVER add backward compatibility** — No shims, aliases, or deprecation layers.
2. **NEVER chain `cd` with `&&`** — `direnv` won't initialize until after all chained commands finish.
3. **NEVER pipe test output through `head`/`tail`** — Redirect to `tmp/` files instead.
4. **Terminal output is invisible** — Always redirect to `tmp/` and read back with `read_file`.
5. **`grep_search` cannot search nested git projects** — Use `read_file` and `list_dir` to explore this codebase.
6. **Use `tmp/` for temporary files** — Never use `/tmp` or other system directories.
7. **Testing dependencies are RUNTIME** — Unlike most gems, `rspec`, `timecop-rspec`, etc. are runtime deps because this gem's purpose is to provide test infrastructure.
8. **100% coverage required** — Both line and branch coverage must be 100%.
