require 'goliath/rack'
require 'goliath/test_helper'
require 'nokogiri'

require 'challenge'

module Helpers
  def sample_offers
    @sample_offers ||= Array.new(3) do |i| 
      { title:     "Offer #{i} title<blah></blah>",
        payout:     i,
        thumbnail: {"lowres" => "#{i}.jpg", "hires" => "#{i}.jpg" } }
    end
  end

  def response_mock(body, status, signature = nil)
    unless signature
      to_be_hashed = body + OfferQuery::API_KEY
      signature = Digest::SHA1.hexdigest to_be_hashed
    end

    response_header = {"X_SPONSORPAY_RESPONSE_SIGNATURE" => signature}
    response_header.stub(:status => status)
    response_mock = mock(:response, response: body,
      response_header: response_header)
  end
end

RSpec.configure do |c|
  c.include Goliath::TestHelper, example_group:
    { file_path: /spec\/functional/ }
  c.include Helpers
end

