require 'rspec_helpers/version'
Dir[
  File.join(__dir__, 'rspec_helpers', 'examples', '*.rb'),
  File.join(__dir__, 'rspec_helpers', 'support', '*.rb')
].each do |file|
  require file
end

module RspecHelpers
end
