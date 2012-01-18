#!/usr/bin/env ruby

require 'goliath'
require 'goliath/rack/templates'
require 'challenge'

class Challenge < Goliath::API
  include Goliath::Rack::Templates

  use Goliath::Rack::Params

  def response env
    if env["REQUEST_METHOD"] == "POST"
      http_wrapper = config[:http_wrapper]
      params = env["params"]
      uid = params["uid"]
      pub0 = params["pub0"]
      page = params["page"]

      offer_query = OfferQuery.new uid, pub0, page
      offers = offer_query.fetch config[:http_wrapper]

      [200, {}, haml(:root, locals: {offers: offers})]
    else
      [200, {}, haml(:root)]
    end
  end
end
