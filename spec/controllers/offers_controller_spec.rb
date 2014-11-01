require "rails_helper"

RSpec.describe OffersController, :type => :controller do

	let(:missing_params){{:uid => nil, :pub0 => "campaign1", :page => "1"}}
	let(:invalid_params){{:asdfasdfpub0 => "campaign1"}}
	let(:params){{:uid => "player1" , :pub0 => "campaign1", :page => "1"}}
  	let(:new_offer){Offer.new}
  	let(:new_offer_params){Offer.new(params)}


	describe "get search" do
		it "assigns @offer.new and " do
			get :search
			expect(assigns(:offer).attributes).to a_hash_including(new_offer.attributes)
			expect(flash[:alert]).to be_nil
		end

		it "renders search template" do
			get :search
			expect(response).to render_template(:search)
		end
	end

	describe "post search" do
		
			it "post valid search request" do
				post :search, offer: params  
				expect(assigns(:offer).attributes).to a_hash_including(new_offer_params.attributes)
			end	

			it "post search request with missing require uid raize offer errors" do
				post :search, offer: missing_params
				expect(flash[:alert]).to be_nil
				expect(assigns(:offer).errors.any?).to be(true)
				expect(assigns(:offer).errors.full_messages[0]).to eq("Uid can't be blank")
			end	

			it "post valid search request" do
				post :search, offer: params 
				expect(flash[:alert]).to be_nil
				expect(assigns(:offer).errors.any?).to be(false)
			end	

			it "post invalid search request raize offer errors" do
				post :search, offer: invalid_params  
				expect(flash[:alert]).to be_nil
				expect(assigns(:offer).errors.any?).to be(true)
				expect(assigns(:offer).errors.full_messages[0]).to eq("Uid can't be blank")
			end	

		end
	end
