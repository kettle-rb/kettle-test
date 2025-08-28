# frozen_string_literal: true
# already required in external.rb

RSpec.configure do |config|
  # RSpec ships with a standard solution.
  #   See: https://www.rubydoc.info/gems/rspec-expectations/RSpec%2FMatchers:output
  # But it has limitations, so the old non-threadsafe approach of SilentStream is still useful.
  config.include(SilentStream)
end
