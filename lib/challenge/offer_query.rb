require 'json'

class OfferQuery

  attr_accessor :uid, :pub0, :page

  DEFAULT_PARAMS = {
    appid:       157,
    format:      "json",
    device_id:   "2b6f0cc904d137be2 e1730235f5664094b 831186",
    locale:      "de",
    ip:          "109.235.143.113",
    offer_types: "112",
    api_key:     "b07a12df7d52e6c118e5d47d3f9e60135b109a1f" }

  def initialize(uid, pub0, page)
    @uid = uid
    @pub0 = pub0
    @page = page
  end

  def fetch(http_wrapper = HttpWrapper)
    params = DEFAULT_PARAMS.merge(uid: uid, pub0: pub0, page: page)
    response = http_wrapper.request params
    if response && response.response_header.status == 200
      received_data = JSON.parse response.body
      if received_data["code"] == "OK"
        received_data["offers"].map do |offer_data|
          Offer.new offer_data["title"], offer_data["payout"], offer_data["thumbnail"]
        end
      end
    end
  end
end

