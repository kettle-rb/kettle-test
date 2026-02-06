# frozen_string_literal: true

module Kettle
  module Test
    # Version namespace
    module Version
      # The current version of kettle-test.
      # @return [String]
      VERSION = "1.0.10"
    end
    VERSION = Version::VERSION # Traditional constant at module level
  end
end
