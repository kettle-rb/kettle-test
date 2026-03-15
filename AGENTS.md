# AGENTS.md - kettle-test Development Guide

## 🎯 Project Overview

`kettle-test` is a **meta tool from kettle-rb to streamline testing** of RubyGem projects. It acts as a shim dependency, pulling in many testing dependencies, and configures RSpec with syntactic sugar to make writing tests easier. It provides environment variable helpers, output silencing, time manipulation, and CI-aware configuration — all pre-wired and ready to go.

**Core Philosophy**: Every kettle-rb gem uses `kettle-test` for test infrastructure. It should never need per-project configuration beyond `require "kettle/test/rspec"`.

**Repository**: https://github.com/kettle-rb/kettle-test
**Current Version**: 1.0.10
**Required Ruby**: >= 2.3.0 (currently developed against Ruby 4.0.1)

## ⚠️ AI Agent Terminal Limitations

### Terminal Output Is Available, but Each Command Is Isolated

**CRITICAL**: AI agents can reliably read terminal output when commands run in the background and the output is polled afterward. However, each terminal command should be treated as a fresh shell with no shared state.

### Use `mise` for Project Environment

**CRITICAL**: The canonical project environment now lives in `mise.toml`, with local overrides in `.env.local` loaded via `dotenvy`.

⚠️ **Watch for trust prompts**: After editing `mise.toml` or `.env.local`, `mise` may require trust to be refreshed before commands can load the project environment. That interactive trust screen can masquerade as missing terminal output, so commands may appear hung or silent until you handle it.

**Recovery rule**: If a `mise exec` command in this repo goes silent, appears hung, or terminal polling stops returning useful output, assume `mise trust` is needed first and recover with:

```bash
mise trust -C /home/pboling/src/kettle-rb/kettle-test
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

Do this before spending time on unrelated debugging; in this workspace, silent `mise` commands are usually a trust problem.

```bash
mise trust -C /home/pboling/src/kettle-rb/kettle-test
```

✅ **CORRECT**:
```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

✅ **CORRECT**:
```bash
eval "$(mise env -C /home/pboling/src/kettle-rb/kettle-test -s bash)" && bundle exec rspec
```

❌ **WRONG**:
```bash
cd /home/pboling/src/kettle-rb/kettle-test
bundle exec rspec
```

❌ **WRONG**:
```bash
cd /home/pboling/src/kettle-rb/kettle-test && bundle exec rspec
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

✅ **CORRECT** — Run the plain command and read the full output afterward:
```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
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
- **Pending Specs** — Ruby-version-aware spec skipping (from `rspec-pending-for`)

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
| `rspec-pending-for` (~> 0.1) | Ruby-version-aware pending |
| `rspec-stubbed_env` (~> 1.0) | ENV stubbing helpers |
| `silent_stream` (~> 1.0) | Output capture/silencing |
| `timecop-rspec` (~> 1.0) | Time manipulation |
| `appraisal2` (~> 3.0) | Multi-dependency testing |
| `backports` (~> 3.0) | Ruby backports |
| `version_gem` (~> 1.1) | Version management |

### Workspace layout

This repo is a sibling project inside the `/home/pboling/src/kettle-rb` workspace, not a vendored dependency under another repo.

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
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

### Coverage Reports

```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bin/rake coverage
```

**Key ENV variables** (set in `mise.toml`, with local overrides in `.env.local`):
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
2. **NEVER expect `cd` to persist** — Every terminal command is isolated; use a self-contained `mise exec -C ... -- ...` invocation.
3. **NEVER pipe test output through `head`/`tail`** — Run tests without truncation so you can inspect the full output.
4. **Terminal commands do not share shell state** — Previous `cd`, `export`, aliases, and functions are not available to the next command.
5. **Use `tmp/` for temporary files** — Never use `/tmp` or other system directories.
6. **Testing dependencies are RUNTIME** — Unlike most gems, `rspec`, `timecop-rspec`, etc. are runtime deps because this gem's purpose is to provide test infrastructure.
7. **100% coverage required** — Both line and branch coverage must be 100%.
