require 'spec_helper'
require File.join(File.dirname(__FILE__), '../../', 'challenge')

describe Challenge do
  let(:err) { Proc.new { fail "API request failed" } }

  def perform_request(http_wrapper_mock = nil, method = :get)
    with_api(Challenge) do |a|
      a.config[:http_wrapper] = http_wrapper_mock if http_wrapper_mock
      if method == :get
        get_request({}, err) {|c| yield c }
      elsif method == :post
        post_request({}, err) {|c| yield c }
      else
        raise "Not supported method"
      end
    end
  end

  describe "Accessing main page" do
    it "should return correct HTTP status" do
      perform_request {|c| c.response_header.status.should == 200 }
    end
  end

  describe "Posting valid form" do
    it "should return correct HTTP status" do
      response_body = {offers: [], code: "OK"}.to_json
      response_mock = mock(:response, response: response_body,
        response_header: mock(:response_header, status: 200))
      http_wrapper_mock = mock(:http_wrapper)
      http_wrapper_mock.should_receive(:request).and_return(response_mock)

      perform_request(http_wrapper_mock, :post) {|c| c.response_header.status.should == 200 }
    end
  end
end

