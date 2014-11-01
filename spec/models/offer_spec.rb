require "rails_helper"

RSpec.describe Offer, :type => :model do

  let(:params){{:uid => "player1" , :pub0 => "campaign1", :page => "1"}}
  let(:new_offer){Offer.new}
  let(:new_offer_params){Offer.new(params)}

  describe "model before search" do

    let(:attributes_keys){["appid", "device_id", "format", "ip", "locale", "offer_types", "page", "pub0", "uid"]}
    let(:base_query_string){"appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&format=json&ip=109.235.143.113&locale=de&offer_types=112"}
    let(:base_query_hash){{"appid"=>157, "device_id"=>"2b6f0cc904d137be2e1730235f5664094b831186", "format"=>"json", "ip"=>"109.235.143.113", "locale"=>"de", "offer_types"=>112}}
    let(:generate_hashkey){{"hashkey"=>"e7cb5b72c4f15aa2dfc62f824012fe3b39a67e98"}}
    
    #initialize
    it "should be initialize with params values" do
      expect(new_offer_params.uid).to eq("player1")
      expect(new_offer_params.pub0).to eq("campaign1")
      expect(new_offer_params.page).to eq("1")
    end

    #initialize(attributes = {})
    it "should be initialize with default values" do
      expect(new_offer.appid).to eq(157)
      expect(new_offer.device_id).to eq("2b6f0cc904d137be2e1730235f5664094b831186")
      expect(new_offer.format).to eq("json")
      expect(new_offer.ip).to eq("109.235.143.113")
      expect(new_offer.locale).to eq("de")
      expect(new_offer.offer_types).to eq(112)
      expect(new_offer.api_key).to eq("b07a12df7d52e6c118e5d47d3f9e60135b109a1f")
      expect(new_offer.url).to eq("http://api.sponsorpay.com/feed/v1/offers.json")
    end

    # valid?
    it "should be invalid" do
      expect(new_offer.valid?).to be(false)
    end  

    # valid?
    it "should be valid" do
      expect(new_offer_params.valid?).to be(true)
    end  

    # success_and_valid?
    it "success_and_valid? should be invalid" do
      expect(new_offer_params.success_and_valid?).to be(false)
    end

    # query_attributes
    it "should not contain values" do
      keys = new_offer_params.send(:query_attributes).keys
      expect(keys).to match_array(attributes_keys)
    end
    
    # generate_hashkey
    it "should be equal" do
      expect(new_offer.send(:generate_hashkey,base_query_string)).to a_hash_including(generate_hashkey)
      expect(new_offer.send(:generate_hashkey,base_query_string + "&#{new_offer_params.api_key}")).to a_hash_including({"hashkey"=>"700c886a4ffebfd2e89ecdcfec8dce484829080d"})
    end  

    # base_query_hash
    it "should be equal" do
      expect(new_offer.send(:base_query_hash)).to eq(base_query_hash)
    end  

    # base_query_string
    it "should be equal" do
      expect(new_offer.send(:base_query_string,[])).to eq(base_query_string)
      expect(new_offer.send(:base_query_string,[new_offer_params.api_key])).to eq(base_query_string + "&#{new_offer_params.api_key}")
    end  
  end


  describe "model after search" do

    let(:invalid_message){{"code"=>"ERROR_INVALID_UID", "message"=>"An invalid user id (uid) was given as a parameter in the request."}}

    # search with no uid 
    it "search should be invalid" do
      expect(new_offer.search).to be(false)
      expect(new_offer.success_and_valid?).to be(false)
      expect(new_offer.data).to a_hash_including(invalid_message)
      expect(new_offer.errors.full_messages[0]).to eq(invalid_message["message"])
      expect(new_offer.offers.blank?).to be(true)
    end

    # search with uid 
    it "search should be invalid" do
      expect(new_offer_params.search).to be(true)
      expect(new_offer_params.success_and_valid?).to be(true)
      expect(new_offer_params.data["code"]).to eq("NO_CONTENT")
      expect(new_offer_params.data["message"]).to eq("Successful request, but no offers are currently available for this user.")
      expect(new_offer_params.offers.blank?).to be(true)
    end
  end  

end
