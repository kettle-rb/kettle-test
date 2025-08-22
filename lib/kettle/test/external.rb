# External-no-config-needed gems
#
# Provides external helpers used by specs, including:
# - rspec/stubbed_env: safe ENV stubbing
# - rspec/block_is_expected: block expectations helper
# - rspec_junit_formatter: JUnit XML formatter
# - silent_stream: output silencing helpers
#
# Files in config/ext may not depend on this library's internals.
# They are auto-required to wire up RSpec configuration.
# Usage:
# describe 'my stubbed test' do
#   before do
#     stub_env('FOO' => 'is bar')
#   end
#   it 'has a value' do
#     expect(ENV['FOO']).to eq('is bar')
#   end
# end
require "rspec/mocks"
require "rspec/stubbed_env"
require "rspec/block_is_expected" # Usage: see https://github.com/galtzo-floss/rspec-block_is_expected#example
require "rspec_junit_formatter"
require "silent_stream"

# Configs of external libraries
require_relative "config/version_gem"

# Automatically load any config added to subdirectories of config/ext
# These are **not** allowed to depend on this library's internals.
path = File.expand_path(__dir__)

# NOTE: Remove #sort when dropping Ruby v2 support; Ruby v3 Dir.globs are pre-sorted
# Load non-rspec library configs
Dir.glob("#{path}/config/ext/*.rb")
  .sort
  .each { |f| require f }

# NOTE: Remove #sort when dropping Ruby v2 support; Ruby v3 Dir.globs are pre-sorted
Dir.glob("#{path}/config/ext/{rspec,filters,helpers,matchers}/**/*.rb")
  .sort
  .each { |f| require f }
