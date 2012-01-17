require 'goliath/rack'
require 'goliath/test_helper'

RSpec.configure do |c|
  c.include Goliath::TestHelper, example_group:
    { file_path: /spec\/functional/ }
end
