require "timecop/rspec"

# Ensure a consistent time for all tests
#
# Integrates timecop-rspec and provides metadata-based time travel/freeze.
# Global baseline time derives from Kettle::Test::GLOBAL_DATE via
# ENV["GLOBAL_TIME_TRAVEL_TIME"]. See README for sequential mode behaviors.
#
# Timecop.travel/freeze any RSpec (describe|context|example) with `:travel` or `:freeze` metadata.
#
# ```ruby
# # Timecop.travel
# it "some description", :travel => Time.new(2014, 11, 15) do
#   Time.now # 2014-11-15 00:00:00
#   sleep 6
#   Time.now # 2014-11-15 00:00:06 (6 seconds later)
# end
#
# # Timecop.freeze
# it "some description", :freeze => Time.new(2014, 11, 15) do
#   Time.now # 2014-11-15 00:00:00
#   sleep 6
#   Time.now # 2014-11-15 00:00:00 (Ruby's time hasn't advanced)
# end
# ```
# If the ENV variable isn't set it will default to today
ENV["GLOBAL_TIME_TRAVEL_TIME"] ||= Kettle::Test::GLOBAL_DATE

RSpec.configure do |config|
  config.around do |example|
    Timecop::Rspec.time_machine(:sequential => Kettle::Test::TIME_MACHINE_SEQUENTIAL).run(example)
  end
end
