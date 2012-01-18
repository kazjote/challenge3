#!/usr/bin/env ruby

require 'goliath'
require 'goliath/rack/templates'
require 'challenge'


class Challenge < Goliath::API
  include Goliath::Rack::Templates

  use Goliath::Rack::Params

  def response(env)
    if env["REQUEST_METHOD"] == "POST"
      params = env["params"]
      offers = OfferQuery.new(params["uid"], params["pub0"], params["page"]).fetch
      [200, {}, haml(:root, locals: {offers: offers})]
    else
      [200, {}, haml(:root)]
    end
  end
end
