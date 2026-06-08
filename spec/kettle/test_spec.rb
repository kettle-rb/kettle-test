# frozen_string_literal: true

require "json"
require "fileutils"
require "open3"
require "rbconfig"
require "tmpdir"

RSpec.describe Kettle::Test do
  include_context "with stubbed env"

  def isolated_kettle_test_snapshot(env = {})
    child_env = ENV.to_hash
    env.each do |key, value|
      if value.nil?
        child_env.delete(key)
      else
        child_env[key] = value
      end
    end

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
      child_env,
      RbConfig.ruby,
      "-e",
      code,
      chdir: File.expand_path("../..", __dir__.to_s)
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
        "KETTLE_DEV_DEBUG" => "false"
      )

      expect(snapshot["debug"]).to be(true)
    end

    it "defaults SILENT to the CI flag when KETTLE_TEST_SILENT is unset" do
      snapshot = isolated_kettle_test_snapshot(
        "CI" => "true",
        "KETTLE_TEST_SILENT" => nil
      )

      expect(snapshot).to include(
        "is_ci" => true,
        "silent" => true
      )
    end

    it "parses RSpec and time-machine toggles from ENV at load time" do
      snapshot = isolated_kettle_test_snapshot(
        "KETTLE_TEST_FULL_BACKTRACE" => "true",
        "KETTLE_TEST_RSPEC_PROFILE_EXAMPLES" => "7",
        "KETTLE_TEST_VERBOSE" => "true",
        "GLOBAL_TIME_TRAVEL_TIME" => "2032-06-01 12:34:56",
        "KETTLE_TEST_TM_SEQUENTIAL" => "false"
      )

      expect(snapshot).to include(
        "full_backtrace" => true,
        "profile_examples_num" => 7,
        "profile_examples" => true,
        "verbose" => true,
        "global_date" => "2032-06-01 12:34:56",
        "time_machine_sequential" => false
      )
    end
  end

  describe "executable help" do
    it "prints usage without running specs or creating a log directory" do
      Dir.mktmpdir do |dir|
        script = File.expand_path("../../exe/kettle-test.sh", __dir__.to_s)

        stdout, stderr, status = Open3.capture3(script, "--help", chdir: dir)

        expect(status).to be_success
        expect(stderr).to eq("")
        expect(stdout).to include("Usage:")
        expect(stdout).to include("bundle exec kettle-test [SPEC_ARGS...]")
        expect(File.exist?(File.join(dir, "tmp", "kettle-test"))).to be(false)
      end
    end

    it "runs from the project root when BUNDLE_GEMFILE points at an Appraisal gemfile" do
      Dir.mktmpdir do |dir|
        script = File.expand_path("../../exe/kettle-test.sh", __dir__.to_s)
        bin_dir = File.join(dir, "bin")
        gemfiles_dir = File.join(dir, "gemfiles")
        fake_bundle = File.join(bin_dir, "bundle")
        appraisal_gemfile = File.join(gemfiles_dir, "coverage.gemfile")

        FileUtils.mkdir_p([bin_dir, gemfiles_dir])
        File.write(File.join(dir, "turbo_tests2.gemspec"), "Gem::Specification.new do |spec|\n  spec.name = 'turbo_tests2'\nend\n")
        File.write(appraisal_gemfile, "source 'https://gem.coop'\n")
        File.write(fake_bundle, <<~BASH)
          #!/usr/bin/env bash
          printf 'FAKE_BUNDLE_PWD=%s\\n' "$PWD"
          printf 'Finished in 0.01 seconds\\n'
          printf '1 example, 0 failures\\n'
        BASH
        FileUtils.chmod("+x", fake_bundle)

        env = {
          "BUNDLE_GEMFILE" => appraisal_gemfile,
          "KETTLE_TEST_RUNNER" => "rspec",
          "K_SOUP_COV_DO" => "false",
          "PATH" => "#{bin_dir}:#{ENV.fetch("PATH")}"
        }

        stdout, stderr, status = Open3.capture3(env, script, chdir: gemfiles_dir)

        expect(status).to be_success
        expect(stderr).to eq("")
        expect(stdout).to include("FAKE_BUNDLE_PWD=#{dir}")
        expect(File.exist?(File.join(dir, "tmp", "kettle-test"))).to be(true)
        expect(File.exist?(File.join(gemfiles_dir, "tmp", "kettle-test"))).to be(false)
      end
    end

    it "prints the RSpec seed in the run highlights when present" do
      Dir.mktmpdir do |dir|
        script = File.expand_path("../../exe/kettle-test.sh", __dir__.to_s)
        bin_dir = File.join(dir, "bin")
        fake_bundle = File.join(bin_dir, "bundle")

        FileUtils.mkdir_p(bin_dir)
        File.write(File.join(dir, "kettle-test-summary.gemspec"), "Gem::Specification.new do |spec|\n  spec.name = 'kettle-test-summary'\nend\n")
        File.write(fake_bundle, <<~BASH)
          #!/usr/bin/env bash
          printf 'Finished in 0.01 seconds (files took 0.02 seconds to load)\\n'
          printf '1 example, 0 failures\\n'
          printf 'Randomized with seed 12345\\n'
        BASH
        FileUtils.chmod("+x", fake_bundle)

        env = {
          "KETTLE_TEST_RUNNER" => "rspec",
          "K_SOUP_COV_DO" => "false",
          "PATH" => "#{bin_dir}:#{ENV.fetch("PATH")}"
        }

        stdout, stderr, status = Open3.capture3(env, script, chdir: dir)

        expect(status).to be_success
        expect(stderr).to eq("")
        expect(stdout).to include("🎲  Randomized with seed 12345")
      end
    end
  end
end
