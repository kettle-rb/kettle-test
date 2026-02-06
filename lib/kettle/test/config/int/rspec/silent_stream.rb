# frozen_string_literal: true

RSpec.configure do |config|
  config.around do |example|
    # Allow tests to run normally when debugging or tagged with check_output
    if Kettle::Test::DEBUG || example.metadata[:check_output]
      example.run
    # Make tests run silently, with shunted STDOUT & STDERR, if ENV var KETTLE_TEST_SILENT == "true"
    else
      # silence_all only silences STDOUT
      # Alternatives:
      #   quietly also silences STDERR
      #   silence_stderr only silences STDERR
      silence_all(Kettle::Test::SILENT) do
        example.run
      end
    end
  end
end
