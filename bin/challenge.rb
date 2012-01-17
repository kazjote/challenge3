#!/usr/bin/env ruby

require 'goliath'
require 'challenge'

class Challenge < Goliath::API
  def response(env)
    response = OfferQuery.new(1, 2, 3).fetch
    [200, {}, response]
  end
end
