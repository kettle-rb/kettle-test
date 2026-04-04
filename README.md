[![Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0][🖼️galtzo-i]][🖼️galtzo-discord] [![ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5][🖼️ruby-lang-i]][🖼️ruby-lang] [![kettle-rb Logo by Aboling0, CC BY-SA 4.0][🖼️kettle-rb-i]][🖼️kettle-rb]

[🖼️galtzo-i]: https://logos.galtzo.com/assets/images/galtzo-floss/avatar-192px.svg
[🖼️galtzo-discord]: https://discord.gg/3qme4XHNKN
[🖼️ruby-lang-i]: https://logos.galtzo.com/assets/images/ruby-lang/avatar-192px.svg
[🖼️ruby-lang]: https://www.ruby-lang.org/
[🖼️kettle-rb-i]: https://logos.galtzo.com/assets/images/kettle-rb/avatar-192px.svg
[🖼️kettle-rb]: https://github.com/kettle-rb

# 🍲 Kettle::Test

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license-ref] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![Open Source Helpers][👽oss-helpi]][👽oss-help] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf] [![CodeQL][🖐codeQL-img]][🖐codeQL] [![Apache SkyWalking Eyes License Compatibility Check][🚎15-🪪-wfi]][🚎15-🪪-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][🖼️galtzo-discord], as I may have missed the [discord notification][🖼️galtzo-discord].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details>
    <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis

Add to your `spec/spec_helper.rb`:

```ruby
require "kettle/test/rspec"

# ... any other config you need to do.

# NOTE: Gemfiles for older rubies (< 2.7) won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
rescue LoadError => error
  # check the error message, and re-raise if not what is expected
  raise error unless error.message.include?("kettle")
end

# This gem (or app)
require "gem-under-test"
```

Now you have many powerful testing tools at your disposal, all fully [documented](#-configuration) and tested.

I expect the current release of this gem to be compatible with Ruby 2.3+,
and concordant releases of JRuby, and TruffleRuby.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎                                                                    |
|------------------------------------------------|-------------------------------------------------------------------------------------|
| 👟 Check it out!                               | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

## 💡 Info you can shake a stick at

| Tokens to Remember      | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace]                                                                                                                                                                                                                                                                          |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby        | [![JRuby 9.1 Compat][💎jruby-9.1i]][🚎jruby-9.1-wf] [![JRuby 9.2 Compat][💎jruby-9.2i]][🚎jruby-9.2-wf] [![JRuby 9.3 Compat][💎jruby-9.3i]][🚎jruby-9.3-wf] <br/> [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎jruby-9.4-wf] [![JRuby current Compat][💎jruby-c-i]][🚎10-j-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]|
| Works with Truffle Ruby | [![Truffle Ruby 22.3 Compat][💎truby-22.3i]][🚎truby-22.3-wf] [![Truffle Ruby 23.0 Compat][💎truby-23.0i]][🚎truby-23.0-wf] [![Truffle Ruby 23.1 Compat][💎truby-23.1i]][🚎truby-23.1-wf] <br/> [![Truffle Ruby 23.2 Compat][💎truby-23.2i]][🚎truby-23.2-wf] [![Truffle Ruby 24.2 Compat][💎truby-24.2i]][🚎truby-24.2-wf] [![Truffle Ruby 25.0 Compat][💎truby-25.0i]][🚎truby-25.0-wf] [![Truffle Ruby current Compat][💎truby-c-i]][🚎9-t-wf]|
| Works with MRI Ruby 4   | [![Ruby 4.0 Compat][💎ruby-4.0i]][🚎11-c-wf] [![Ruby current Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 3   | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎ruby-3.0-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎ruby-3.1-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎ruby-3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎ruby-3.3-wf] [![Ruby 3.4 Compat][💎ruby-3.4i]][🚎ruby-3.4-wf]|
| Works with MRI Ruby 2   | [![Ruby 2.3 Compat][💎ruby-2.3i]][🚎ruby-2.3-wf] [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎ruby-2.4-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎ruby-2.5-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎ruby-2.6-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎ruby-2.7-wf]|
| Support & Community     | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]                                       |
| Source                  | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc]                                                                                                                                                         |
| Documentation           | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki]                                                                                          |
| Compliance              | [![License: MIT][📄license-img]][📄license-ref] [![Compatible with Apache Software Projects: Verified by SkyWalking Eyes][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style                   | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2]                                                                                                                  |
| Maintainer 🎖️          | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto]                                                      |
| `...` 💖                | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub]  [🛖][💖🛖hut] [🧪][💖🧪lab]                                                                   |

### Compatibility

Compatible with MRI Ruby 2.3.0+, and concordant releases of JRuby, and TruffleRuby.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎 and the color 💚 green 💚             |
|------------------------------------------------|--------------------------------------------------------|
| 👟 Check it out!                               | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

### Federated DVCS

<details markdown="1">
  <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository        | Status                                                                | Issues                    | PRs                      | Wiki                      | CI                       | Discussions                  |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [kettle-rb/kettle-test on GitLab][📜src-gl]   | The Truth                                                             | [💚][🤝gl-issues]         | [💚][🤝gl-pulls]         | [💚][📜gl-wiki]           | 🐭 Tiny Matrix           | ➖                            |
| 🧊 [kettle-rb/kettle-test on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate])                             | [💚][🤝cb-issues]         | [💚][🤝cb-pulls]         | ➖                         | ⭕️ No Matrix             | ➖                            |
| 🐙 [kettle-rb/kettle-test on GitHub][📜src-gh]   | Another Mirror                                                        | [💚][🤝gh-issues]         | [💚][🤝gh-pulls]         | [💚][📜gh-wiki]           | 💯 Full Matrix           | [💚][gh-discussions]         |
| 🎮️ [Discord Server][✉️discord-invite]          | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/kettle-rb/kettle-test/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/kettle-test)](https://tidelift.com/subscription/pkg/rubygems-kettle-test?utm_source=rubygems-kettle-test&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details markdown="1">
  <summary>Need enterprise-level guarantees?</summary>

The maintainers of this and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source packages you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact packages you use.

[![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]

- 💡Subscribe for support guarantees covering _all_ your FLOSS dependencies
- 💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]
- 💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers

Alternatively:

- [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]
- [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork]
- [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]

</details>

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

```console
bundle add kettle-test
```

If bundler is not being used to manage dependencies, install the gem by executing:

```console
gem install kettle-test
```

### 🔒 Secure Installation

<details markdown="1">
  <summary>For Medium or High Security Installations</summary>

This gem is cryptographically signed and has verifiable [SHA-256 and SHA-512][💎SHA_checksums] checksums by
[stone_checksums][💎stone_checksums]. Be sure the gem you install hasn’t been tampered with
by following the instructions below.

Add my public key (if you haven’t already; key expires 2045-04-29) as a trusted certificate:

```console
gem cert --add <(curl -Ls https://raw.github.com/galtzo-floss/certs/main/pboling.pem)
```

You only need to do that once.  Then proceed to install with:

```console
gem install kettle-test -P HighSecurity
```

The `HighSecurity` trust profile will verify signed gems, and not allow the installation of unsigned dependencies.

If you want to up your security game full-time:

```console
bundle config set --global trust-policy MediumSecurity
```

`MediumSecurity` instead of `HighSecurity` is necessary if not all the gems you use are signed.

NOTE: Be prepared to track down certs for signed gems and add them the same way you added mine.

</details>

## ⚙️ Configuration

Add to your `spec/spec_helper.rb`:

```ruby
require "kettle/test/rspec"

# ... any other config you need to do.

# NOTE: Gemfiles for older rubies (< 2.7) won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
rescue LoadError => error
  # check the error message, and re-raise if not what is expected
  raise error unless error.message.include?("kettle")
end

# This gem (or app)
require "gem-under-test"
```

That's it!  Additional customizations can be done by setting environment variables.

### Environment Variables

Below are the environment variables recognized by kettle-test. Unless otherwise specified, set values to the string "true" to enable a boolean feature, or provide the noted type.

- DEBUG (String: "true"/"false")
    - Overrides default silencing for the entire run; when true, STDOUT/STDERR are not silenced by this library.
    - Default: "false". If KETTLE_TEST_DEBUG is not set, DEBUG is used.
- GLOBAL_TIME_TRAVEL_TIME (String: Date/Time)
    - Global start time for Timecop across examples when using time travel.
    - Example: "2014-11-15" or "2014-11-15 13:45:00".
    - Default: falls back to GLOBAL_TIME_TRAVEL_DATE if set, else today.
- GLOBAL_TIME_TRAVEL_DATE (String: Date)
    - Alternate way to set a global date used when GLOBAL_TIME_TRAVEL_TIME is not provided.
    - Default: today (Date.today.to_s).
- KETTLE_TEST_DEBUG (String: "true"/"false")
    - Same as DEBUG but namespaced for this gem. Takes precedence over DEBUG.
    - Default: "false".
- CI (String: "true"/"false")
    - Signals a CI environment. When true, examples tagged :skip_ci are excluded.
    - Also used as the default for KETTLE_TEST_SILENT when not set.
    - Default: unset/empty → treated as false.
- KETTLE_TEST_SILENT (String: "true"/"false")
    - Controls silencing of STDOUT/STDERR during specs (unless :check_output is used or DEBUG is true).
    - Default: value of CI (true on CI, false locally unless CI=true).
- KETTLE_TEST_VERBOSE (String: "true"/"false")
    - Reserved for future verbose logging toggles. Default: "false".
- KETTLE_TEST_FULL_BACKTRACE (String: "true"/"false")
    - When true, enables RSpec full backtraces.
    - Default: "false".
- KETTLE_TEST_RSPEC_PROFILE_EXAMPLES (Integer as String)
    - When > 0, RSpec will profile the slowest N examples or example groups.
    - Example: KETTLE_TEST_RSPEC_PROFILE_EXAMPLES=10
    - Default: "0" (disabled).
- KETTLE_TEST_TM_SEQUENTIAL (String: "true"/"false")
    - Controls Timecop sequential time machine mode for RSpec examples (see below).
    - Default: "true".
- PARALLEL_TEST_FIRST_IS_1 (String: "true"/"false") and TEST_ENV_NUMBER (String)
    - Used to detect parallel test runs via Kettle::Test.is_parallel_test?. Not generally required to set manually.
    - Default: unset (treated as non-parallel unless provided by your parallel test runner).

### TimeCop-RSpec

#### Global Time Travel

Using global time travel will `Timecop.travel` any example that isn't
already time traveling. I.e. example level timecop metadata will take
precedence.

```sh
GLOBAL_TIME_TRAVEL_TIME=2014-11-15 bundle exec rspec spec/some_directory/
```

The global time travel can also be skipped. You may want to skip
time travel when testing with some external service, such as redis,
where you can't modify time the same way as within ruby.

```ruby
it "some example that can't time travel", :skip_global_travel do
  # Time.now will be real time
end
```

#### Regular Time Machine

```ruby
ENV["KETTLE_TEST_TM_SEQUENTIAL"] = "false"
```

The regular time machine will run each example at the time specified by the
RSpec metadata, or the global travel time.

#### Sequential Time Machine

```ruby
ENV["KETTLE_TEST_TM_SEQUENTIAL"] = "true"
```

The sequential time machine is almost the same as the regular time machine,
except that it will sometimes resume time travel.

Global travel will always resume from when the previous global traveled
example ended. E.g.

```ruby
# GLOBAL_TIME_TRAVEL_TIME=2014-11-15 bundle exec rspec some_spec.rb

it "example 1" do
  Time.now # => 2014-11-15 00:00:00
  sleep 6
end

it "example 2" do
  Time.now # => 2014-11-15 00:00:06 (resumed from end of previous example)
end
```

## 🔧 Basic Usage

### Shared Context "with rake"

Make sure to require "rake" before you require "kettle/test" (or "kettle/dev" since it will require this library).

If you do the shared context will be available to use in your specs automatically.

```ruby
include_context "with rake", "demo" do
  let(:tmp_rakelib) do
    Dir.mktmpdir("with_rake_spec_")
  end
  let(:task_dir) { tmp_rakelib }
  let(:rakelib) { tmp_rakelib }
  # Provide args for the rake task invocation
  let(:task_args) { ["Bob"] }
end
```

See the spec for a more complete example: [with_rake_spec.rb](spec/kettle/text/support/shared_contexts/with_rake_spec.rb)

### RSpec Time Machine Tags :freeze and :travel

Timecop.travel/freeze any RSpec (describe|context|example) with
`:travel` or `:freeze` metadata.

```ruby
# Timecop.travel
it "some description", travel: Time.new(2014, 11, 15) do
  Time.now # 2014-11-15 00:00:00
  sleep 6
  Time.now # 2014-11-15 00:00:06 (6 seconds later)
end

# Timecop.freeze
it "some description", freeze: Time.new(2014, 11, 15) do
  Time.now # 2014-11-15 00:00:00
  sleep 6
  Time.now # 2014-11-15 00:00:00 (Ruby's time hasn't advanced)
end
```

Following spec's local travel will resume when specified time is the same as the
previous examples specified time. If the time is different, it will
start from the current examples specified time.

```ruby
describe SomeUnit, travel: Time.new(2014, 11, 15) do
  it "example 1" do
    Time.now # => 2014-11-15 00:00:00
    sleep 6
  end

  it "example 2" do
    Time.now # => 2014-11-15 00:00:06 (resumed from end of previous example)
  end

  it "example 3", travel: Time.new(1982, 6, 16) do
    Time.now # => 1982-06-16 00:00:00
  end
end
```

### Stubbed ENV in examples

Use rspec-stubbed_env to safely set and restore environment variables in specs.

```ruby
RSpec.describe("stubbed env") do
  # kettle-test includes these globally, so they are always available
  # include_context "with stubbed env"
  # include_context "with hidden env"

  before do
    stub_env("FOO" => "is bar")
    hide_env("PATH")
  end

  it "uses the stubbed value" do
    expect(ENV["FOO"]).to(eq("is bar"))
  end

  it "has no path" do
    expect(ENV["PATH"]).to(be_nil)
  end
end
```

### Silencing output and checking output

STDOUT/STDERR are silenced by default when KETTLE_TEST_SILENT is true (defaults to true on CI). To assert output from the code under test, tag examples/groups with :check_output, or run with DEBUG=true to disable silencing globally.

```ruby
RSpec.describe("output", :check_output) do
  it "prints" do
    puts "This will be visible in test output"
    expect(true).to(be(true))
  end
end
```

Or run:

```sh
DEBUG=true bundle exec rspec
```

### Version-based pending and skipping

Use rspec-pending_for to conditionally pending or skip examples based on Ruby version and engine.

The `pending_for` and `skip_for` macros support flexible version specifications:

**Supported version forms:**

- String: exact or partial match to RUBY_VERSION (e.g., "3.2.4", "3.2", or "3")
- Array of strings: any matching entry triggers pending/skip
- Range of Gem::Version: inclusive/exclusive endpoints respected
- Range of Integer: compares major version only (e.g., 2..3 for Ruby 2.x and 3.x)

**Supported engines:** :ruby (MRI), :jruby, :truffleruby

**Specifying versions:**

```ruby
RSpec.describe("version-specific behavior") do
  # Exact version string
  it "pends only on Ruby 3.2.4" do
    pending_for(engine: :ruby, versions: "3.2.4")
    # ...
  end

  # Multiple exact versions
  it "pends on a set of MRI versions" do
    pending_for(engine: :ruby, versions: %w[2.7.10 3.0.7 3.1.6])
  end

  # Match any engine by version (no :engine)
  it "skips on any engine if version equals 2.7.8" do
    skip_for(versions: "2.7.8", reason: "Known upstream incompatibility")
  end

  # Range of Gem::Version (inclusive)
  it "pends for MRI >= 2.6.0 and <= 3.0.0" do
    pending_for(
      engine: :ruby,
      versions: (Gem::Version.new("2.6.0")..Gem::Version.new("3.0.0")),
    )
  end

  # Range of Gem::Version (exclusive end)
  it "skips for MRI >= 3.1.0 and < 3.3.0" do
    skip_for(
      engine: :ruby,
      versions: (Gem::Version.new("3.1.0")...Gem::Version.new("3.3.0")),
    )
  end

  # Range of Integer (major versions)
  it "pends on all Ruby 2.x and 3.x" do
    pending_for(versions: (2..3), reason: "Major series currently affected")
  end

  it "skips on Ruby 2.x but not 3.x" do
    skip_for(versions: (2...3)) # 2 <= version < 3
  end
end
```

**Using with RSpec tags:**

```ruby
RSpec.configure do |config|
  # Auto-skip examples requiring specific Ruby versions via tags
  config.before(:each, :requires_ruby_32) do
    skip_for(
      reason: "Requires Ruby >= 3.2",
      versions: %w[2.7 3.0 3.1],
    )
  end
end

RSpec.describe("something") do
  it "runs only on Ruby 3.2+", :requires_ruby_32 do
    # ... your example code ...
  end
end
```

**Notes:**

- Omit :engine to match any Ruby engine (MRI, JRuby, TruffleRuby)
- Omit :versions with :engine to match all versions of that engine
- JRuby and TruffleRuby are matched using their RUBY_VERSION compatibility
- String matching supports partial versions ("3.1" matches "3.1.x" but not "3.0.x")
- Provide :reason to override the default message in reports

### CI-only filtering

Examples or groups tagged with :skip_ci are excluded on CI (CI=true).

```ruby
RSpec.describe("flaky external call", :skip_ci) do
  it "runs locally but is skipped on CI" do
    # ...
  end
end
```

### Profile slowest examples

Set KETTLE_TEST_RSPEC_PROFILE_EXAMPLES to a positive integer to enable RSpec profiling.

```sh
KETTLE_TEST_RSPEC_PROFILE_EXAMPLES=10 bundle exec rspec
```

### Full backtraces

Enable full backtraces from RSpec to aid debugging.

```sh
KETTLE_TEST_FULL_BACKTRACE=true bundle exec rspec
```

## 🦷 FLOSS Funding

While kettle-rb tools are free software and will always be, the project would benefit immensely from some funding.
Raising a monthly budget of... "dollars" would make the project more sustainable.

We welcome both individual and corporate sponsors! We also offer a
wide array of funding channels to account for your preferences
(although currently [Open Collective][🖇osc] is our preferred funding platform).

**If you're working in a company that's making significant use of kettle-rb tools we'd
appreciate it if you suggest to your company to become a kettle-rb sponsor.**

You can support the development of kettle-rb tools via
[GitHub Sponsors][🖇sponsor],
[Liberapay][⛳liberapay],
[PayPal][🖇paypal],
[Open Collective][🖇osc]
and [Tidelift][🏙️entsup-tidelift].

| 📍 NOTE                                                                                                                                                                                                              |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| If doing a sponsorship in the form of donation is problematic for your company <br/> from an accounting standpoint, we'd recommend the use of Tidelift, <br/> where you can get a support-like subscription instead. |

### Open Collective for Individuals

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/kettle-rb#backer)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-INDIVIDUALS:START -->
No backers yet. Be the first!
<!-- OPENCOLLECTIVE-INDIVIDUALS:END -->

### Open Collective for Organizations

Become a sponsor and get your logo on our README on GitHub with a link to your site. [[Become a sponsor](https://opencollective.com/kettle-rb#sponsor)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-ORGANIZATIONS:START -->
No sponsors yet. Be the first!
<!-- OPENCOLLECTIVE-ORGANIZATIONS:END -->

[kettle-readme-backers]: https://github.com/kettle-rb/kettle-test/blob/main/exe/kettle-readme-backers

### Another way to support open-source

I’m driven by a passion to foster a thriving open-source community – a space where people can tackle complex problems, no matter how small.  Revitalizing libraries that have fallen into disrepair, and building new libraries focused on solving real-world challenges, are my passions.  I was recently affected by layoffs, and the tech jobs market is unwelcoming. I’m reaching out here because your support would significantly aid my efforts to provide for my family, and my farm (11 🐔 chickens, 2 🐶 dogs, 3 🐰 rabbits, 8 🐈‍ cats).

If you work at a company that uses my work, please encourage them to support me as a corporate sponsor. My work on gems you use might show up in `bundle fund`.

I’m developing a new library, [floss_funding][🖇floss-funding-gem], designed to empower open-source developers like myself to get paid for the work we do, in a sustainable way. Please give it a look.

**[Floss-Funding.dev][🖇floss-funding.dev]: 👉️ No network calls. 👉️ No tracking. 👉️ No oversight. 👉️ Minimal crypto hashing. 💡 Easily disabled nags**

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [reek](REEK), [issues][🤝gh-issues], or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/kettle-rb/kettle-test/-/graphs/main][🚎contributors-gl]

<details>
    <summary>⭐️ Star History</summary>

<a href="https://star-history.com/#kettle-rb/kettle-test&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=kettle-rb/kettle-test&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=kettle-rb/kettle-test&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=kettle-rb/kettle-test&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This Library adheres to [![Semantic Versioning 2.0.0][📌semver-img]][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

> dropping support for a platform is both obviously and objectively a breaking change <br/>
>—Jordan Harband ([@ljharb](https://github.com/ljharb), maintainer of SemVer) [in SemVer issue 716][📌semver-breaking]

I understand that policy doesn't work universally ("exceptions to every rule!"),
but it is the policy here.
As such, in many cases it is good to specify a dependency on this library using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("kettle-test", "~> 1.0")
```

<details markdown="1">
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

SemVer should, IMO, but doesn't explicitly, say that dropping support for specific Platforms
is a *breaking change* to an API, and for that reason the bike shedding is endless.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available under the following license: [AGPL-3.0-only](AGPL-3.0-only.md).
See [LICENSE.md][📄license] for details.

If none of the available licenses suit your use case, please [contact us](mailto:floss@glatzo.com) to discuss a custom commercial license.

### © Copyright

See [LICENSE.md][📄license] for the official copyright notice.

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor kettle-rb/kettle-test on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

### Please give the project a star ⭐ ♥.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/kettle-rb
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/kettle-rb
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/kettle-rb
[🖇osc-backers]: https://opencollective.com/kettle-rb#backer
[🖇osc-backers-i]: https://opencollective.com/kettle-rb/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/kettle-rb#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/kettle-rb/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/kettle-rb?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/kettle-rb?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/kettle-rb?style=for-the-badge
[🖇osc]: https://opencollective.com/kettle-rb
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge&logo=discord
[✉️ruby-friends-img]: https://img.shields.io/badge/daily.dev-%F0%9F%92%8E_Ruby_Friends-0A0A0A?style=for-the-badge&logo=dailydotdev&logoColor=white
[✉️ruby-friends]: https://app.daily.dev/squads/rubyfriends

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/kettle-rb/kettle-test
[⛳️namespace-img]: https://img.shields.io/badge/namespace-Kettle::Test-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://bestgems.org/gems/kettle-test
[⛳️name-img]: https://img.shields.io/badge/name-kettle--test-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/kettle-rb/kettle-test.svg
[⛳️tag]: http://github.com/kettle-rb/kettle-test/releases
[🚂maint-blog]: http://www.railsbling.com/tags/kettle-test
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/LinkedIn-Profile-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://wellfound.com/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https://ruby.social&style=flat&logo=mastodon&label=Ruby%20@galtzo
[💖🦋bluesky]: https://bsky.app/profile/galtzo.com
[💖🦋bluesky-img]: https://img.shields.io/badge/@galtzo.com-0285FF?style=flat&logo=bluesky&logoColor=white
[💖🌳linktree]: https://linktr.ee/galtzo
[💖🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=flat&logo=linktree
[💖💁🏼‍♂️devto]: https://dev.to/galtzo
[💖💁🏼‍♂️devto-img]: https://img.shields.io/badge/dev.to-0A0A0A?style=flat&logo=devdotto&logoColor=white
[💖💁🏼‍♂️aboutme]: https://about.me/peter.boling
[💖💁🏼‍♂️aboutme-img]: https://img.shields.io/badge/about.me-0A0A0A?style=flat&logo=aboutme&logoColor=white
[💖🧊berg]: https://codeberg.org/pboling
[💖🐙hub]: https://github.org/pboling
[💖🛖hut]: https://sr.ht/~galtzo/
[💖🧪lab]: https://gitlab.com/pboling
[👨🏼‍🏫expsup-upwork]: https://www.upwork.com/freelancers/~014942e9b056abdf86?mp_source=share
[👨🏼‍🏫expsup-upwork-img]: https://img.shields.io/badge/UpWork-13544E?style=for-the-badge&logo=Upwork&logoColor=white
[👨🏼‍🏫expsup-codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[👨🏼‍🏫expsup-codementor-img]: https://img.shields.io/badge/CodeMentor-Get_Help-1abc9c?style=for-the-badge&logo=CodeMentor&logoColor=white
[🏙️entsup-tidelift]: https://tidelift.com/subscription/pkg/rubygems-kettle-test?utm_source=rubygems-kettle-test&utm_medium=referral&utm_campaign=readme
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/kettle-rb/kettle-test/
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/kettle-rb/kettle-test
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/kettle-rb/kettle-test
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/kettle-rb/kettle-test/-/wikis/home
[📜gh-wiki]: https://github.com/kettle-rb/kettle-test/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-examples-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-examples-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://bestgems.org/gems/kettle-test
[👽dl-ranki]: https://img.shields.io/gem/rd/kettle-test.svg
[👽oss-help]: https://www.codetriage.com/kettle-rb/kettle-test
[👽oss-helpi]: https://www.codetriage.com/kettle-rb/kettle-test/badges/users.svg
[👽version]: https://bestgems.org/gems/kettle-test
[👽versioni]: https://img.shields.io/gem/v/kettle-test.svg
[🏀qlty-mnt]: https://qlty.sh/gh/kettle-rb/projects/kettle-test
[🏀qlty-mnti]: https://qlty.sh/gh/kettle-rb/projects/kettle-test/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/kettle-rb/projects/kettle-test/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/kettle-rb/projects/kettle-test/coverage.svg
[🏀codecov]: https://codecov.io/gh/kettle-rb/kettle-test
[🏀codecovi]: https://codecov.io/gh/kettle-rb/kettle-test/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/kettle-rb/kettle-test?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/kettle-rb/kettle-test/badge.svg?branch=main
[🖐codeQL]: https://github.com/kettle-rb/kettle-test/security/code-scanning
[🖐codeQL-img]: https://github.com/kettle-rb/kettle-test/actions/workflows/codeql-analysis.yml/badge.svg
[🚎ruby-2.3-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-2.3.yml
[🚎ruby-2.4-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-2.4.yml
[🚎ruby-2.5-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-2.5.yml
[🚎ruby-2.6-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-2.6.yml
[🚎ruby-2.7-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-2.7.yml
[🚎ruby-3.0-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-3.0.yml
[🚎ruby-3.1-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-3.1.yml
[🚎ruby-3.2-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-3.2.yml
[🚎ruby-3.3-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-3.3.yml
[🚎ruby-3.4-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/ruby-3.4.yml
[🚎jruby-9.1-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby-9.1.yml
[🚎jruby-9.2-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby-9.2.yml
[🚎jruby-9.3-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby-9.3.yml
[🚎jruby-9.4-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby-9.4.yml
[🚎truby-22.3-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-22.3.yml
[🚎truby-23.0-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-23.0.yml
[🚎truby-23.1-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-23.1.yml
[🚎truby-23.2-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-23.2.yml
[🚎truby-24.2-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-24.2.yml
[🚎truby-25.0-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffleruby-25.0.yml
[🚎2-cov-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/heads.yml/badge.svg
[🚎5-st-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/style.yml/badge.svg
[🚎9-t-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/unlocked_deps.yml/badge.svg
[🚎15-🪪-wf]: https://github.com/kettle-rb/kettle-test/actions/workflows/license-eye.yml
[🚎15-🪪-wfi]: https://github.com/kettle-rb/kettle-test/actions/workflows/license-eye.yml/badge.svg
[💎ruby-2.3i]: https://img.shields.io/badge/Ruby-2.3-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.4i]: https://img.shields.io/badge/Ruby-3.4-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-4.0i]: https://img.shields.io/badge/Ruby-4.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-22.3i]: https://img.shields.io/badge/Truffle_Ruby-22.3-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.0i]: https://img.shields.io/badge/Truffle_Ruby-23.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.1i]: https://img.shields.io/badge/Truffle_Ruby-23.1-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.2i]: https://img.shields.io/badge/Truffle_Ruby-23.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-24.2i]: https://img.shields.io/badge/Truffle_Ruby-24.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-25.0i]: https://img.shields.io/badge/Truffle_Ruby-25.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-9.1i]: https://img.shields.io/badge/JRuby-9.1-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.2i]: https://img.shields.io/badge/JRuby-9.2-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.3i]: https://img.shields.io/badge/JRuby-9.3-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.4i]: https://img.shields.io/badge/JRuby-9.4-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/kettle-rb/kettle-test/issues
[🤝gh-pulls]: https://github.com/kettle-rb/kettle-test/pulls
[🤝gl-issues]: https://gitlab.com/kettle-rb/kettle-test/-/issues
[🤝gl-pulls]: https://gitlab.com/kettle-rb/kettle-test/-/merge_requests
[🤝cb-issues]: https://codeberg.org/kettle-rb/kettle-test/issues
[🤝cb-pulls]: https://codeberg.org/kettle-rb/kettle-test/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/kettle-rb/kettle-test/graphs/tree.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/kettle-rb/kettle-test/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=kettle-rb/kettle-test
[🚎contributors-gl]: https://gitlab.com/kettle-rb/kettle-test/-/graphs/main
[🪇conduct]: CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]: https://gitmoji.dev
[📌gitmoji-img]: https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-5.053-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.md
[📄license-compat]: https://dev.to/galtzo/how-to-check-license-compatibility-41h0
[📄license-compat-img]: https://img.shields.io/badge/Apache_Compatible:_Category_A-%E2%9C%93-259D6C.svg?style=flat&logo=Apache
[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/kettle-test
[🚎yard-head]: https://kettle-test.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/kettle-rb/kettle-test/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/
