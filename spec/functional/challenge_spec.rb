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
    it "should return HTTP status Found" do
      perform_request {|c| c.response_header.status.should == 200 }
    end
  end

  describe "Posting valid form" do
    context "when there are some offers" do
      before do
        response_body = {offers: sample_offers, code: "OK"}.to_json
        response_mock = response_mock response_body, 200
        http_wrapper_mock = mock(:http_wrapper, :request => response_mock)
        perform_request(http_wrapper_mock, :post) {|c| @http_client = c }
      end

      let(:page) { Nokogiri::HTML(@http_client.response) }
      let(:first_offer) { sample_offers.first }

      it "should return HTTP status Found" do
        @http_client.response_header.status.should == 200
      end

      it "should contain correct number of offers" do
        page.css(".offer").length.should == 3
      end

      it "should contain offer titles" do
        page.css(".offer .title").first.inner_text.should =~ /#{first_offer[:title]}/
      end

      it "should contain offer payouts" do
        page.css(".offer .payout").first.inner_text.should =~ /#{first_offer[:payout]}/
      end

      it "should contain offer thumbnails" do
        url = first_offer[:thumbnail]["lowres"]
        page.css(".offer .thumbnail img[src='#{url}']").should_not be_empty
      end
    end

    context "when there are no offers" do
      before do
        response_body = {offers: sample_offers, code: "NO_CONTENT"}.to_json
        response_mock = response_mock response_body, 200
        http_wrapper_mock = mock(:http_wrapper, :request => response_mock)
        perform_request(http_wrapper_mock, :post) {|c| @http_client = c }
      end

      let(:page) { Nokogiri::HTML(@http_client.response) }

      it "should return HTTP status Found" do
        @http_client.response_header.status.should == 200
      end

      it "should contain message about no offers" do
        page.css(".no_offers").inner_text.should =~ /No offers/
      end
    end
  end
end

