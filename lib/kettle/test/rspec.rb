require_relative "external"

# Entry point for RSpec integrations provided by kettle-test.
# Requires external helpers, this library, then wires internal configuration.
require "kettle/test"

require_relative "internal"

# A gem's test harness should do require "rake" if it is their dependency,
#   and they define a rake task they want to test.
require_relative "support/shared_contexts/with_rake" if defined?(Rake)
