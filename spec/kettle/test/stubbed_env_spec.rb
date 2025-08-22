# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

RSpec.describe Kettle::Test do
  include_context "with stubbed env"

  it "stubs ENV safely within the example" do
    stub_env("FANCY_ENV" => "yup")
    expect(ENV["FANCY_ENV"]).to eq("yup")
  end

  it "restores ENV after the example" do
    expect(ENV["FANCY_ENV"]).to be_nil
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
