# frozen_string_literal: true

require "json"
require "open3"
require "rbconfig"

RSpec.describe Kettle::Test do
  include_context "with stubbed env"

  def isolated_kettle_test_snapshot(env = {})
    code = <<~RUBY
      require "bundler/setup"
      require "json"
      require "rspec/core"
      require "kettle/test"

      puts JSON.generate(
        debug: Kettle::Test::DEBUG,
        is_ci: Kettle::Test::IS_CI,
        silent: Kettle::Test::SILENT,
        full_backtrace: Kettle::Test::FULL_BACKTRACE,
        profile_examples_num: Kettle::Test::RSPEC_PROFILE_EXAMPLES_NUM,
        profile_examples: Kettle::Test::RSPEC_PROFILE_EXAMPLES,
        verbose: Kettle::Test::VERBOSE,
        global_date: Kettle::Test::GLOBAL_DATE,
        time_machine_sequential: Kettle::Test::TIME_MACHINE_SEQUENTIAL,
      )
    RUBY

    stdout, stderr, status = Open3.capture3(
      env,
      RbConfig.ruby,
      "-e",
      code,
      chdir: File.expand_path("../..", __dir__.to_s),
    )

    raise "isolated kettle/test load failed:\n#{stderr}" unless status.success?

    JSON.parse(stdout)
  end

  describe "::is_parallel_test?" do
    it "returns false when TEST_ENV_NUMBER is not set" do
      stub_env("TEST_ENV_NUMBER" => nil)
      expect(described_class.is_parallel_test?).to be(false)
    end

    it "returns true when parallel mode constant is true and TEST_ENV_NUMBER present" do
      stub_env("TEST_ENV_NUMBER" => "2")
      # Ensure the constant is true for this example regardless of real env at load time
      stub_const("Kettle::Test::TREAT_AS_PARALLEL", true)
      expect(described_class.is_parallel_test?).to be(true)
    end

    it "returns false when parallel mode constant is false even if TEST_ENV_NUMBER present" do
      stub_env("TEST_ENV_NUMBER" => "3")
      stub_const("Kettle::Test::TREAT_AS_PARALLEL", false)
      expect(described_class.is_parallel_test?).to be(false)
    end
  end

  describe "ENV-driven configuration" do
    it "prefers KETTLE_TEST_DEBUG over KETTLE_DEV_DEBUG" do
      snapshot = isolated_kettle_test_snapshot(
        "KETTLE_TEST_DEBUG" => "true",
        "KETTLE_DEV_DEBUG" => "false",
      )

      expect(snapshot["debug"]).to be(true)
    end

    it "defaults SILENT to the CI flag when KETTLE_TEST_SILENT is unset" do
      snapshot = isolated_kettle_test_snapshot(
        "CI" => "true",
        "KETTLE_TEST_SILENT" => nil,
      )

      expect(snapshot).to include(
        "is_ci" => true,
        "silent" => true,
      )
    end

    it "parses RSpec and time-machine toggles from ENV at load time" do
      snapshot = isolated_kettle_test_snapshot(
        "KETTLE_TEST_FULL_BACKTRACE" => "true",
        "KETTLE_TEST_RSPEC_PROFILE_EXAMPLES" => "7",
        "KETTLE_TEST_VERBOSE" => "true",
        "GLOBAL_TIME_TRAVEL_TIME" => "2032-06-01 12:34:56",
        "KETTLE_TEST_TM_SEQUENTIAL" => "false",
      )

      expect(snapshot).to include(
        "full_backtrace" => true,
        "profile_examples_num" => 7,
        "profile_examples" => true,
        "verbose" => true,
        "global_date" => "2032-06-01 12:34:56",
        "time_machine_sequential" => false,
      )
    end
  end
end
