require 'spec_helper'

require 'json'

describe OfferQuery do

  let(:timestamp) { 1326881692 }
  subject { OfferQuery.new 1, 2, 3, timestamp }

  it "should pass correct params to SponsorPay during query" do
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
      hashkey: "80eaa12211a6ba67a51d606cbd5fd0355c09d5b2").
      and_return response_mock "{}", 200

    subject.fetch
  end

  context "when there are some results" do
    let(:fetched_offers) { subject.offers }

    before do
      response_body = {offers: sample_offers, code: "OK"}.to_json
      response_mock = response_mock response_body, 200
      HttpWrapper.should_receive(:request).and_return response_mock
      subject.fetch
    end

    describe "status" do
      it { should be_found }
    end

    it "should return correct number of offers" do
      fetched_offers.size.should == 3
    end

    describe "fetched offers" do
      it "should have correct title" do
        fetched_offers[0].title.should == sample_offers[0][:title]
        fetched_offers[2].title.should == sample_offers[2][:title]
      end

      it "should have correct payout" do
        fetched_offers[0].payout.should == sample_offers[0][:payout]
        fetched_offers[2].payout.should == sample_offers[2][:payout]
      end

      it "should have correct thumbnail" do
        fetched_offers[0].thumbnail.should == sample_offers[0][:thumbnail]
        fetched_offers[2].thumbnail.should == sample_offers[2][:thumbnail]
      end
    end
  end

  context "when there are no results" do
    before do
      response_body = {code: "NO_CONTENT"}.to_json
      response_mock = response_mock response_body, 200
      HttpWrapper.should_receive(:request).and_return response_mock
      subject.fetch
    end

    describe "status" do
      it { should be_found }
    end

    it "should return empty array of offers" do
      subject.offers.should == []
    end
  end

  context "when response signature is incorrect" do
    before do
      response_mock = response_mock "{}", 200, "invalid signature"
      HttpWrapper.should_receive(:request).and_return response_mock
    end

    it "should raise an exception" do
      lambda { subject.fetch }.should raise_exception
    end
  end
end

