require 'goliath/rack'
require 'goliath/test_helper'

require 'challenge'

module Helpers
  def sample_offers
    @sample_offers ||= Array.new(3) do |i| 
      { title:     "Offer #{i} title",
        payout:     i,
        thumbnail: {"lowres" => "#{i}.jpg", "hires" => "#{i}.jpg" } }
    end
  end
end

RSpec.configure do |c|
  c.include Goliath::TestHelper, example_group:
    { file_path: /spec\/functional/ }
  c.include Helpers
end
