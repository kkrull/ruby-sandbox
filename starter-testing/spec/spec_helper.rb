require 'support/globally_included_module'
require 'support/shared_module'

RSpec.configure do |config|
  config.include GloballyIncludedModule
  config.include SharedModule
end
