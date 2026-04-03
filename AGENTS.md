# AGENTS.md - Development Guide

## 🎯 Project Overview

```bash
eval "$(mise env -C /path/to/project -s bash)" && bundle exec rspec
```

❌ **WRONG** — Do not rely on a previous command changing directories:

```bash
cd /path/to/project
bundle exec rspec
```

❌ **WRONG** — A chained `cd` does not give directory-change hooks time to update the environment:

This project is a **RubyGem** managed with the [kettle-rb](https://github.com/kettle-rb) toolchain.

**Minimum Supported Ruby**: See the gemspec `required_ruby_version` constraint.
**Local Development Ruby**: See `.tool-versions` for the version used in local development (typically the latest stable Ruby).

When you do run tests, keep the full output visible so you can inspect failures completely.

## ⚠️ AI Agent Terminal Limitations

### Terminal Output Is Available, but Each Command Is Isolated

### Running Commands

Always make commands self-contained. Use `mise exec -C /home/pboling/src/kettle-rb/prism-merge -- ...` so the command gets the project environment in the same invocation.
If the command is complicated write a script in local tmp/ and then run the script.

### Use `mise` for Project Environment

**CRITICAL**: The canonical project environment lives in `mise.toml`, with local overrides in `.env.local` loaded via `dotenvy`.

⚠️ **Watch for trust prompts**: After editing `mise.toml` or `.env.local`, `mise` may require trust to be refreshed before commands can load the project environment. Until that trust step is handled, commands can appear hung or produce no output, which can look like terminal access is broken.

**Recovery rule**: If a `mise exec` command goes silent or appears hung, assume `mise trust` is the first thing to check. Recover by running:

```bash
mise trust -C /home/pboling/src/kettle-rb/kettle-test
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

```bash
mise trust -C /path/to/project
mise exec -C /path/to/project -- bundle exec rspec
```

Do this before spending time on unrelated debugging; in this workspace pattern, silent `mise` commands are usually a trust problem first.

```bash
mise trust -C /home/pboling/src/kettle-rb/kettle-test
```

✅ **CORRECT** — Run self-contained commands with `mise exec`:

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

```bash
cd /path/to/project && bundle exec rspec
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
- Simple commands that do not require much shell escaping
- Running scripts (prefer writing a script over a complicated command with shell escaping)

### NEVER Pipe Test Commands Through head/tail

❌ **ABSOLUTELY FORBIDDEN**:
```bash
bundle exec rspec 2>&1 | tail -50
```

```bash
mise exec -C /path/to/project -- bundle exec rspec
```

✅ **CORRECT** — If you need shell syntax first, load the environment in the same command:

```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

## 🏗️ Architecture

### What kettle-test Provides

```ruby
before do
  stub_env("MY_ENV_VAR" => "value")
end

before do
  hide_env("HOME", "USER")
end
```

### Dependency Tags

Use dependency tags to conditionally skip tests when optional dependencies are not available:

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

### Toolchain Dependencies

This gem is part of the **kettle-rb** ecosystem. Key development tools:

| Tool | Purpose |
|------|---------|
| `kettle-dev` | Development dependency: Rake tasks, release tooling, CI helpers |
| `kettle-test` | Test infrastructure: RSpec helpers, stubbed_env, timecop |
| `kettle-jem` | Template management and gem scaffolding |

### Executables (from kettle-dev)

| Executable | Purpose |
|-----------|---------|
| `kettle-release` | Full gem release workflow |
| `kettle-pre-release` | Pre-release validation |
| `kettle-changelog` | Changelog generation |
| `kettle-dvcs` | DVCS (git) workflow automation |
| `kettle-commit-msg` | Commit message validation |
| `kettle-check-eof` | EOF newline validation |

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

```
lib/
├── <gem_namespace>/           # Main library code
│   └── version.rb             # Version constant (managed by kettle-release)
spec/
├── fixtures/                  # Test fixture files (NOT auto-loaded)
├── support/
│   ├── classes/               # Helper classes for specs
│   └── shared_contexts/       # Shared RSpec contexts
├── spec_helper.rb             # RSpec configuration (loaded by .rspec)
gemfiles/
├── modular/                   # Modular Gemfile components
│   ├── coverage.gemfile       # SimpleCov dependencies
│   ├── debug.gemfile          # Debugging tools
│   ├── documentation.gemfile  # YARD/documentation
│   ├── optional.gemfile       # Optional dependencies
│   ├── rspec.gemfile          # RSpec testing
│   ├── style.gemfile          # RuboCop/linting
│   └── x_std_libs.gemfile     # Extracted stdlib gems
├── ruby_*.gemfile             # Per-Ruby-version Appraisal Gemfiles
└── Appraisal.root.gemfile     # Root Gemfile for Appraisal builds
.git-hooks/
├── commit-msg                 # Commit message validation hook
├── prepare-commit-msg         # Commit message preparation
├── commit-subjects-goalie.txt # Commit subject prefix filters
└── footer-template.erb.txt    # Commit footer ERB template
```

## 🔧 Development Workflows

### Running Tests

```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bundle exec rspec
```

```bash
mise exec -C /path/to/project -- env K_SOUP_COV_MIN_HARD=false bundle exec rspec spec/path/to/spec.rb
```

### Coverage Reports

```bash
mise exec -C /home/pboling/src/kettle-rb/kettle-test -- bin/rake coverage
```

```bash
mise exec -C /path/to/project -- bin/rake coverage
mise exec -C /path/to/project -- bin/kettle-soup-cover -d
```

**Key ENV variables** (set in `mise.toml`, with local overrides in `.env.local`):

- `K_SOUP_COV_DO=true` – Enable coverage
- `K_SOUP_COV_MIN_LINE` – Line coverage threshold
- `K_SOUP_COV_MIN_BRANCH` – Branch coverage threshold
- `K_SOUP_COV_MIN_HARD=true` – Fail if thresholds not met

## 📝 Usage in Other Gems

### Loading in spec_helper.rb

```ruby
# In any kettle-rb gem's spec/spec_helper.rb:
require "kettle/test/rspec"
```

Full suite spec runs:

```bash
mise exec -C /path/to/project -- bundle exec rspec
```

For single file, targeted, or partial spec runs the coverage threshold **must** be disabled.
Use the `K_SOUP_COV_MIN_HARD=false` environment variable to disable hard failure:

## 🧪 Testing Patterns

### Test Infrastructure

- Uses `kettle-test` for RSpec helpers (stubbed_env, block_is_expected, silent_stream, timecop)
- Uses `Dir.mktmpdir` for isolated filesystem tests
- Spec helper is loaded by `.rspec` — never add `require "spec_helper"` to spec files

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

### Code Quality

```bash
mise exec -C /path/to/project -- bundle exec rake reek
mise exec -C /path/to/project -- bundle exec rubocop-gradual
```

### Releasing

```bash
bin/kettle-pre-release    # Validate everything before release
bin/kettle-release        # Full release workflow
```

## 📝 Project Conventions

### Freeze Block Preservation

Template updates preserve custom code wrapped in freeze blocks:

```ruby
# kettle-jem:freeze
# ... custom code preserved across template runs ...
# kettle-jem:unfreeze
```

### Modular Gemfile Architecture

Gemfiles are split into modular components under `gemfiles/modular/`. Each component handles a specific concern (coverage, style, debug, etc.). The main `Gemfile` loads these modular components via `eval_gemfile`.

### Timecop Integration

### Forward Compatibility with `**options`

**CRITICAL**: All constructors and public API methods that accept keyword arguments MUST include `**options` as the final parameter for forward compatibility.

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

```ruby
RSpec.describe SomeClass, :prism_merge do
  # Skipped if prism-merge is not available
end
```

## 🚫 Common Pitfalls

1. **NEVER add backward compatibility** — No shims, aliases, or deprecation layers.
2. **NEVER expect `cd` to persist** — Every terminal command is isolated; use a self-contained `mise exec -C ... -- ...` invocation.
3. **NEVER pipe test output through `head`/`tail`** — Run tests without truncation so you can inspect the full output.
4. **Terminal commands do not share shell state** — Previous `cd`, `export`, aliases, and functions are not available to the next command.
5. **Use `tmp/` for temporary files** — Never use `/tmp` or other system directories.
6. **Testing dependencies are RUNTIME** — Unlike most gems, `rspec`, `timecop-rspec`, etc. are runtime deps because this gem's purpose is to provide test infrastructure.
7. **100% coverage required** — Both line and branch coverage must be 100%.

1. **NEVER pipe test output through `head`/`tail`** — Run tests without truncation so you can inspect the full output.
