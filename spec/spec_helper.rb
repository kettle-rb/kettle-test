# frozen_string_literal: true

ENV["FLOSS_FUNDING_KETTLE__TEST"] = "Free-as-in-beer"

# Config for development dependencies of this library
# i.e., not configured by this library
# N/A

# NOTE: Gemfiles for older rubies won't have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
rescue LoadError => error
  # check the error message and re-raise when unexpected
  raise error unless error.message.include?("kettle")
end

# RSpec config provided by this library
# NOTE: Also loads *this* library
require "kettle/test/rspec"
