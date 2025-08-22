# frozen_string_literal: true

RSpec.configure do |config|
  # Settings that only exist in RSpec v3+ are unavailable during transpec's RSpec syntax upgrade.
  # Other settings may be easier to upgrade to modern defaults after the uograde,
  #   so we leave them alone during transpec.
  # :nocov:
  if Kettle::Test::TRANSPEC
    config.expect_with(:rspec) do |c|
      c.syntax = [:expect, :should]
    end
    config.treat_symbols_as_metadata_keys_with_true_values = true
  else
    config.expect_with(:rspec) do |c|
      c.syntax = :expect
    end

    # Enable flags like --only-failures and --next-failure
    config.example_status_persistence_file_path = ".rspec_status"

    # Disable RSpec exposing methods globally on `Module` and `main`
    config.disable_monkey_patching!

    # Optionally turn on full backtrace
    config.full_backtrace = Kettle::Test::FULL_BACKTRACE

    # Profile Slowest Specs?
    config.profile_examples = Kettle::Test::RSPEC_PROFILE_EXAMPLES_NUM if Kettle::Test::RSPEC_PROFILE_EXAMPLES

    # Exclude examples/groups tagged with :skip_ci when running on CI
    # Usage: add `:skip_ci` to any example or group you want to skip on CI
    if Kettle::Test::IS_CI
      config.filter_run_excluding(:skip_ci => true)
    end
  end
  # :nocov:
end
