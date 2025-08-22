require_relative "external"

# Entry point for RSpec integrations provided by kettle-test.
# Requires external helpers, this library, then wires internal configuration.
require "kettle/test"

require_relative "internal"
