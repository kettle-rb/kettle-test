# Required for vcr gem Ruby <= 2.4
# It is also required for other dependencies of this gem (not sure if test or runtime).
# The test suite, which doesn't use vcr, fails on Ruby 2.4 without backports.
# That's why backports is a full dependency.
#
# Ruby 2.3 / 2.4 can fail with:
# | An error occurred while loading spec_helper.
# | Failure/Error: require "vcr"
# |
# | NoMethodError:
# |   undefined method `delete_prefix' for "CONTENT_LENGTH":String
# | # ./spec/config/vcr.rb:3:in `require'
# | # ./spec/config/vcr.rb:3:in `<top (required)>'
# | # ./spec/spec_helper.rb:8:in `require_relative'
# | # ./spec/spec_helper.rb:8:in `<top (required)>'
# So that's why we need backports.

require "backports/2.5.0/string/delete_prefix"
