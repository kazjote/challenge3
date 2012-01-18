require 'json'
require 'digest/sha1'

require 'em-synchrony/em-http'

class OfferQuery
  include EventMachine::HttpEncoding

  attr_reader :uid, :pub0, :page, :timestamp

  DEFAULT_PARAMS = {
    appid:       157,
    device_id:   "2b6f0cc904d137be2 e1730235f5664094b 831186",
    locale:      "de",
    ip:          "109.235.143.113",
    offer_types: "112" }

  API_KEY = "b07a12df7d52e6c118e5d47d3f9e60135b109a1f"

  def initialize(uid, pub0, page, timestamp = Time.now.to_i)
    @uid = uid
    @pub0 = pub0
    @page = page
    @timestamp = timestamp
  end

  def fetch http_wrapper = HttpWrapper
    response = http_wrapper.request params_hash.dup.merge(:hashkey => hashkey)

    if response && response.response_header.status == 200
      received_data = JSON.parse response.response
      if received_data["code"] == "OK"
        received_data["offers"].map do |offer_data|
          Offer.new offer_data["title"], offer_data["payout"], offer_data["thumbnail"]
        end
      end
    end
  end

  protected

  def params_hash
    @params_hash ||=
      DEFAULT_PARAMS.merge(uid: uid, pub0: pub0, page: page, timestamp: timestamp)
  end

  def hashkey
    keys = params_hash.keys.sort
    query = keys.map {|k| "#{k}=#{params_hash[k]}"}.join("&")
    Digest::SHA1.hexdigest "#{query}&#{API_KEY}"
  end
end

