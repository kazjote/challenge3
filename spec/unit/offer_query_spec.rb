require 'spec_helper'

require 'json'

describe OfferQuery do

  it "should pass correct params to SponsorPay during query" do
    timestamp = 1326881692

    HttpWrapper.should_receive(:request).with(
      appid: 157,
      device_id: "2b6f0cc904d137be2 e1730235f5664094b 831186",
      ip: "109.235.143.113",
      locale: "de",
      offer_types: "112",
      page: 3,
      pub0: 2,
      timestamp: 1326881692,
      uid: 1,
      hashkey: "80eaa12211a6ba67a51d606cbd5fd0355c09d5b2")

    OfferQuery.new(1, 2, 3, timestamp).fetch
  end

  context "when there are some results" do
    let(:offers_data) do
      Array.new(3) do |i| 
        { title:     "Offer #{i} title",
          payout:     i,
          thumbnail: {"lowres" => "#{i}.jpg", "hires" => "#{i}.jpg" } }
      end
    end

    let(:fetched_offers) { OfferQuery.new(1, 2, 3).fetch }

    before do
      response_body = {offers: offers_data, code: "OK"}.to_json
      response_mock = mock(:response, response: response_body,
        response_header: mock(:response_header, status: 200))
      HttpWrapper.should_receive(:request).and_return response_mock
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

