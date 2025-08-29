# frozen_string_literal: true

# We need Rake loaded so that kettle/test/rspec (and thus the shared context) can be required.
require "rake"
# In case spec_helper loaded kettle/test/rspec before Rake was defined, load the context directly here.
require "kettle/test/support/shared_contexts/with_rake"

RSpec.describe "rake demo:print" do # rubocop:disable RSpec/DescribeClass
  context "with a temporary rakelib and a demo task", :check_output do
    require "tmpdir"

    # Include the shared context first so that our overriding lets below take precedence.
    include_context "with rake", "demo" do
      let(:tmp_rakelib) do
        Dir.mktmpdir("with_rake_spec_")
      end
      # Required by the shared context (override the raising defaults)
      let(:task_dir) { tmp_rakelib }
      let(:rakelib) { tmp_rakelib }
      # Provide args for the rake task invocation
      let(:task_args) { ["Bob"] }
    end

    around do |example|
      require "fileutils"
      # Create a rake file BEFORE the shared context's before(:each) runs
      File.open(File.join(tmp_rakelib, "demo.rake"), "w") do |f|
        f.write(<<~'RAKE')
          namespace :demo do
            desc "Print a greeting"
            task :print, [:name] do |_t, args|
              puts "Hello #{args[:name] || 'world'}"
            end
          end
        RAKE
      end

      begin
        example.run
      ensure
        # Cleanup tasks loaded into the Rake application for isolation
        Rake::Task.tasks.each { |t| t.clear }
        # Remove the temp directory and its contents
        FileUtils.rm_rf(tmp_rakelib) if File.directory?(tmp_rakelib)
      end
    end

    it "derives task_name from the top-level description by stripping the 'rake ' prefix" do
      expect(task_name).to eq("demo:print")
    end

    it "sets Rake.application to the isolated rake_app instance" do
      expect(Rake.application).to be(rake_app)
    end

    it "loads the rake file and defines the target task" do
      expect(rake_task).to be_a(Rake::Task)
      expect(rake_task.name).to eq("demo:print")
    end

    it "invokes the task with provided arguments and prints expected output" do
      expect { invoke }.to output(/Hello Bob/).to_stdout
    end

    it "excludes the current rake file from the loaded files list via helper" do
      required_path = File.join(rakelib, "demo.rake").to_s

      # Simulate the scenario where the rake file is already in $LOADED_FEATURES
      added = false
      unless $LOADED_FEATURES.include?(required_path)
        $LOADED_FEATURES << required_path
        added = true
      end

      begin
        excluded = loaded_files_excluding_current_rake_file("demo")
        # The helper should exclude exactly this file path
        expect(excluded).not_to include(required_path)
      ensure
        # Clean up our simulation
        $LOADED_FEATURES.delete(required_path) if added
      end
    end
  end
end
