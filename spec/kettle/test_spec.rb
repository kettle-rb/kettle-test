# frozen_string_literal: true

RSpec.describe Kettle::Test do
  include_context "with stubbed env"

  describe "::is_parallel_test?" do
    it "returns false when TEST_ENV_NUMBER is not set" do
      stub_env("TEST_ENV_NUMBER" => nil)
      expect(described_class.is_parallel_test?).to be(false)
    end

    it "returns true when parallel mode constant is true and TEST_ENV_NUMBER present" do
      stub_env("TEST_ENV_NUMBER" => "2")
      # Ensure the constant is true for this example regardless of real env at load time
      stub_const("Kettle::Test::TREAT_AS_PARALLEL", true)
      expect(described_class.is_parallel_test?).to be(true)
    end

    it "returns false when parallel mode constant is false even if TEST_ENV_NUMBER present" do
      stub_env("TEST_ENV_NUMBER" => "3")
      stub_const("Kettle::Test::TREAT_AS_PARALLEL", false)
      expect(described_class.is_parallel_test?).to be(false)
    end
  end
end
