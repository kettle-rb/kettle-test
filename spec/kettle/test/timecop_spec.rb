# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

RSpec.describe Kettle::Test do
  it "freezes time when :freeze metadata is provided", :freeze => Time.new(2014, 11, 15) do
    t1 = Time.now
    sleep 0.1
    t2 = Time.now
    expect(t2).to eq(t1)
  end

  it "travels time when :travel metadata is provided", :travel => Time.new(2014, 11, 15) do
    t1 = Time.now
    sleep 0.1
    t2 = Time.now
    expect(t2).to be >= t1
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
