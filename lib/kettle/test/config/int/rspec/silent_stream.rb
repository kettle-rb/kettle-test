# frozen_string_literal: true

RSpec.configure do |config|
  # RSpec ships with a standard solution.
  #   See: https://www.rubydoc.info/gems/rspec-expectations/RSpec%2FMatchers:output
  # But it has limitations, so the old non-threadsafe approach of SilentStream is still useful.
  config.include(SilentStream)

  config.around do |example|
    # Allow tests to run normally when debugging or tagged with check_output
    if Kettle::Test::DEBUG || example.metadata[:check_output]
      example.run
    # Make tests run silently, with shunted STDOUT & STDERR, if ENV var KETTLE_TEST_SILENT == "true"
    else
      silence_all(Kettle::Test::SILENT) do
        example.run
      end
    end
  end
end
