require 'spec_helper'

describe OfferQuery do

  module HttpWrapper
    def self.requests
      @@requests
    end

    def self.reset
      @@requests = []
    end

    def self.request(params)
      @@requests << params
    end
  end

  before(:each) { HttpWrapper.reset }

  describe "params passed to SponsorPay during query" do
    before { OfferQuery.new(1, 2, 3).fetch }

    let(:params) { HttpWrapper.requests.first }

    specify { params[:uid].should == 1 }
    specify { params[:pub0].should == 2 }
    specify { params[:page].should == 3 }
    specify { params[:appid].should == 157 }
    specify { params[:locale].should == "de" }
    specify { params[:ip].should == "109.235.143.113" }
    specify { params[:offer_types].should == "112" }
    specify { params[:device_id].should == "2b6f0cc904d137be2 e1730235f5664094b 831186" }
  end
end

