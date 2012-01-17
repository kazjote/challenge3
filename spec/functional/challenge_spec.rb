require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'bin/challenge')

describe Challenge do
  let(:err) { Proc.new { fail "API request failed" } }

  it "should return correct reponse" do
    with_api(Challenge) do
      get_request({}, err) do |c|
        c.response.should == "ok"
      end
    end
  end
end
