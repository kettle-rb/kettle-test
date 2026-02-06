# Configs of external libraries that depend on this library's internals
#
# Auto-loads internal RSpec configuration and any additional integrations under
# config/int and its subfolders.
# Files in config/ext may depend on this library's internals.
require_relative "config/int/rspec_block_is_expected"
require_relative "config/int/rspec_pending_for"
require_relative "config/int/rspec/rspec_core"
require_relative "config/int/rspec/silent_stream"

# Automatically load any config added to subdirectories of config/int
# These are allowed to depend on this library's internals.
path = File.expand_path(__dir__)

# NOTE: Remove #sort when dropping Ruby v2 support; Ruby v3 Dir.globs are pre-sorted
# Load non-rspec library configs
Dir.glob("#{path}/config/int/*.rb")
  .sort
  .each { |f| require f }

# NOTE: Remove #sort when dropping Ruby v2 support; Ruby v3 Dir.globs are pre-sorted
Dir.glob("#{path}/config/int/{rspec,filters,helpers,matchers}/**/*.rb")
  .sort
  .each { |f| require f }
