require 'goliath/rack'
require 'goliath/test_helper'
require 'nokogiri'

require 'challenge'

module Helpers
  def sample_offers
    @sample_offers ||= Array.new(3) do |i| 
      { title:     "Offer #{i} title",
        payout:     i,
        thumbnail: {"lowres" => "#{i}.jpg", "hires" => "#{i}.jpg" } }
    end
  end

  def response_mock(body, status)
    response_mock = mock(:response, response: body,
      response_header: mock(:response_header, status: status))
  end
end

RSpec.configure do |c|
  c.include Goliath::TestHelper, example_group:
    { file_path: /spec\/functional/ }
  c.include Helpers
end

