require 'spec_helper'

require 'json'

describe OfferQuery do

  module HttpMock
    def self.set_response new_response
      @@response = new_response
    end

    def self.request_params
      @@request_params
    end

    def self.reset
      @@request_params = nil
      @@response = nil
    end

    def self.request(params)
      @@request_params = params
      @@response
    end
  end

  class ResponseMock < Struct.new(:code, :body)
    ResponseHeaderMock = Struct.new(:status)

    def response_header
      ResponseHeaderMock.new code
    end
  end

  before(:each) { HttpMock.reset }

  describe "params passed to SponsorPay during query" do
    before { OfferQuery.new(1, 2, 3).fetch HttpMock }

    let(:params) { HttpMock.request_params }

    specify { params[:uid].should == 1 }
    specify { params[:pub0].should == 2 }
    specify { params[:page].should == 3 }
    specify { params[:appid].should == 157 }
    specify { params[:locale].should == "de" }
    specify { params[:ip].should == "109.235.143.113" }
    specify { params[:offer_types].should == "112" }
    specify { params[:device_id].should == "2b6f0cc904d137be2 e1730235f5664094b 831186" }
  end

  context "when there are some results" do
    let(:offers_data) do
      Array.new(3) do |i| 
        { title:     "Offer #{i} title",
          payout:     i,
          thumbnail: {"lowres" => "#{i}.jpg", "hires" => "#{i}.jpg" } }
      end
    end

    let(:fetched_offers) { OfferQuery.new(1, 2, 3).fetch HttpMock }

    before do
      response_body = {offers: offers_data, code: "OK"}.to_json
      HttpMock.set_response ResponseMock.new 200, response_body
    end

    it "should return correct number of offers" do
      fetched_offers.size.should == 3
    end

    describe "fetched offers" do
      it "should have correct title" do
        fetched_offers[0].title.should == offers_data[0][:title]
        fetched_offers[2].title.should == offers_data[2][:title]
      end

      it "should have correct payout" do
        fetched_offers[0].payout.should == offers_data[0][:payout]
        fetched_offers[2].payout.should == offers_data[2][:payout]
      end

      it "should have correct thumbnail" do
        fetched_offers[0].thumbnail.should == offers_data[0][:thumbnail]
        fetched_offers[2].thumbnail.should == offers_data[2][:thumbnail]
      end
    end
  end
end

