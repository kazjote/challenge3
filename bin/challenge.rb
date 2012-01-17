#!/usr/bin/env ruby

require 'goliath'
require 'mobile_offer'

class Challenge < Goliath::API
  def response(env)
    [200, {}, "ok"]
  end
end
