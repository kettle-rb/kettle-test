# frozen_string_literal: true

require_relative "test/version"

# Kettle namespace for the kettle-rb ecosystem of gems.
module Kettle
  # Test support and RSpec integration for kettle-rb ecosystem.
  #
  # Exposes environment-controlled constants and helpers that tune RSpec behavior
  # (profiling, backtraces, output silencing, CI filters) and provides a minimal
  # API for detecting parallel test execution.
  #
  # See README for configuration and usage examples.
  module Test
    # Base error class for kettle-test specific failures.
    class Error < StandardError; end

    # String#casecmp? was added in Ruby 2.4, so fallback to String#casecmp
    # @return [Boolean] whether debug mode is enabled (disables silencing)
    DEBUG = ENV.fetch("KETTLE_TEST_DEBUG", ENV.fetch("DEBUG", "false")).casecmp("true").zero?
    # @return [Boolean] whether running in a CI environment (CI=true)
    IS_CI = ENV.fetch("CI", "").casecmp("true").zero?
    # @return [Boolean] when true, enables full backtraces in RSpec
    FULL_BACKTRACE = ENV.fetch("KETTLE_TEST_FULL_BACKTRACE", "false").casecmp("true").zero?
    # @return [Integer] number of examples to profile (0 disables profiling)
    RSPEC_PROFILE_EXAMPLES_NUM = ENV.fetch("KETTLE_TEST_RSPEC_PROFILE_EXAMPLES", "0").to_i
    # @return [Boolean] whether profiling is enabled
    RSPEC_PROFILE_EXAMPLES = RSPEC_PROFILE_EXAMPLES_NUM > 0
    # If RSpec's version is < 3, enable `transpec` to facilitate the upgrade.
    # @return [Gem::Version] active RSpec version
    RSPEC_VERSION = ::Gem::Version.new(RSpec::Core::Version::STRING)
    # @return [Boolean] when true, STDOUT/STDERR are silenced during specs (unless :check_output or DEBUG)
    SILENT = ENV.fetch("KETTLE_TEST_SILENT", IS_CI.to_s).casecmp("true").zero?
    # @return [Boolean] whether transpec compatibility mode should be enabled
    TRANSPEC = ::Gem::Version.new("3.0") > RSPEC_VERSION
    # @return [Boolean] whether the environment signals a parallel test run
    TREAT_AS_PARALLEL = ENV.fetch("PARALLEL_TEST_FIRST_IS_1", "").casecmp("true").zero?
    # @return [Boolean] reserved for verbose logging toggles
    VERBOSE = ENV.fetch("KETTLE_TEST_VERBOSE", "false").casecmp("true").zero?
    # time starts at midnight on GLOBAL_DATE
    # @return [String] global travel time or date used as a baseline for timecop
    GLOBAL_DATE = ENV.fetch("GLOBAL_TIME_TRAVEL_TIME", ENV.fetch("GLOBAL_TIME_TRAVEL_DATE", Date.today.to_s))
    # @return [Boolean] when true, use sequential time machine mode for timecop-rspec
    TIME_MACHINE_SEQUENTIAL = ENV.fetch("KETTLE_TEST_TM_SEQUENTIAL", "true").casecmp("true").zero?

    class << self
      # Detects whether tests are running in parallel.
      #
      # Many parallel test runners set PARALLEL_TEST_FIRST_IS_1=true and provide
      # TEST_ENV_NUMBER for each worker. This helper checks those signals.
      # @return [Boolean]
      def is_parallel_test?
        TREAT_AS_PARALLEL && !ENV.fetch("TEST_ENV_NUMBER", "").empty?
      end
    end
  end
end

Kettle::Test::Version.class_eval do
  extend VersionGem::Basic
end
