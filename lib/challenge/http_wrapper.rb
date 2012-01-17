require 'em-synchrony'
require 'em-synchrony/em-http'

module HttpWrapper
  def self.request(params)
    uri = "http://api.sponsorpay.com/feed/v1/offers.json"
    EventMachine::HttpRequest.new(uri).get query: params
  end
end
