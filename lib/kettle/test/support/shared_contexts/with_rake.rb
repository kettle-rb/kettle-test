# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

# Inspired by: https://thoughtbot.com/blog/test-rake-tasks-like-a-boss
# This version doesn't require a Rails app!
# This file will only be required if Rake is defined
# require "rake"

# Usage:
#     include_context "with rake", "demo" do
#       let(:tmp_rakelib) do
#         Dir.mktmpdir("with_rake_spec_")
#       end
#       # Required by the shared context (override the raising defaults)
#       let(:task_dir) { tmp_rakelib }
#       let(:rakelib) { tmp_rakelib }
#       # Provide args for the rake task invocation
#       let(:task_args) { ["Bob"] }
#     end
#
# See for more details: spec/kettle/text/support/shared_contexts/with_rake_spec.rb
#
RSpec.shared_context("with rake") do |task_base_name|
  let(:rake_app) { Rake::Application.new }
  let(:task_name) { self.class.top_level_description.sub(/\Arake /, "") }
  # A gem depending on this gem, and using this shared context must define task_dir
  # let(:task_dir) { "lib/gem_checksums/rakelib" }
  let(:task_dir) { raise ArgumentError, "define task_dir in the block of `include_context 'with rake', basename do ... end`" }
  let(:task_args) { [] }
  let(:invoke) { rake_task.invoke(*task_args) }
  # A gem depending on this gem, and using this shared context must define rakelib
  # let(:rakelib) { File.join(__dir__, "..", "..", "..", task_dir) }
  let(:rakelib) { raise ArgumentError, "define rakelib in the block of `include_context 'with rake', basename do ... end`" }
  let(:rake_task) { Rake::Task[task_name] }

  include_context "with stubbed env"

  def loaded_files_excluding_current_rake_file(task_base_name)
    $".reject { |file| file == File.join(rakelib, "#{task_base_name}.rake").to_s }
  end

  before do
    Rake.application = rake_app
    Rake.application.rake_require(task_base_name, [rakelib], loaded_files_excluding_current_rake_file(task_base_name))
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
