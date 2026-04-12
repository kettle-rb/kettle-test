# frozen_string_literal: true

require "json"
require "kettle/test/rspec"
require "open3"
require "rbconfig"

RSpec.describe Kettle::Test::RSpec do
  describe "kettle/test/rspec bootstrap" do
    def isolated_rspec_bootstrap(env = {}, prelude: nil)
      code = <<~RUBY
        require "bundler/setup"
        require "json"
        require "rspec/core"
        #{prelude}
        require "kettle/test/rspec"

        puts JSON.generate(
          with_rake: !RSpec.world.shared_example_group_registry.find([:main], "with rake").nil?,
          top_level_describe: TOPLEVEL_BINDING.eval("respond_to?(:describe)"),
          example_status_persistence_file_path: RSpec.configuration.example_status_persistence_file_path,
          skip_ci_filter: RSpec.configuration.filter_manager.exclusions.rules[:skip_ci],
        )
      RUBY

      stdout, stderr, status = Open3.capture3(
        env,
        RbConfig.ruby,
        "-e",
        code,
        chdir: File.expand_path("../../..", __dir__.to_s),
      )

      raise "isolated kettle/test/rspec load failed:\n#{stderr}" unless status.success?

      JSON.parse(stdout)
    end

    it "keeps the with rake shared context opt-in until Rake is loaded" do
      snapshot = isolated_rspec_bootstrap

      expect(snapshot["with_rake"]).to be(false)
    end

    it "autoloads the with rake shared context when Rake is loaded first" do
      snapshot = isolated_rspec_bootstrap(prelude: 'require "rake"')

      expect(snapshot["with_rake"]).to be(true)
    end

    it "applies the non-monkey-patching and CI defaults to RSpec" do
      snapshot = isolated_rspec_bootstrap({"CI" => "true"})

      expect(snapshot).to include(
        "top_level_describe" => false,
        "example_status_persistence_file_path" => ".rspec_status",
        "skip_ci_filter" => true,
      )
    end
  end
end
