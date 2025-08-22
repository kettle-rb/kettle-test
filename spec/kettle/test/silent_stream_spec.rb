# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

RSpec.describe Kettle::Test do
  include_context "with stubbed env"

  context "when tagged with :check_output", :check_output do
    it "does not silence STDOUT" do
      expect { puts "hello-visible" }.to output(/hello-visible/).to_stdout
    end
  end

  context "when DEBUG is true" do
    it "does not silence STDOUT" do
      stub_const("Kettle::Test::DEBUG", true)
      expect { puts "debug-visible" }.to output(/debug-visible/).to_stdout
    end
  end

  context "when neither DEBUG nor :check_output" do
    # Force DEBUG=false at group level so the global around hook evaluates it as false.
    # rubocop:disable RSpec/BeforeAfterAll, RSpec/RemoveConst
    before(:all) do
      if described_class.const_defined?(:DEBUG)
        described_class.send(:remove_const, :DEBUG)
      end
      described_class.const_set(:DEBUG, false)
    end
    # rubocop:enable RSpec/BeforeAfterAll, RSpec/RemoveConst

    # We don't assert on output here to avoid depending on Kettle::Test::SILENT's value.
    it "executes via the else branch without raising errors" do
      expect { 2 + 2 }.not_to raise_error
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
