# frozen_string_literal: true

# already required in external.rb

RSpec.configure do |config|
  config.include_context("with stubbed env")
  config.include_context("with hidden env")
end
