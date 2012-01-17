require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'bin/challenge')

describe Challenge do
  let(:err) { Proc.new { fail "API request failed" } }

  def perform_request
    with_api(Challenge) do
      get_request({}, err) do |c|
        yield c
      end
    end
  end

  it "should return correct reponse body" do
    perform_request {|c| c.response.should == "ok" }
  end
end
