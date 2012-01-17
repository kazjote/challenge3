#!/usr/bin/env ruby

require 'goliath'

class Challenge < Goliath::API
  def response(env)
    [200, {}, "ok"]
  end
end
