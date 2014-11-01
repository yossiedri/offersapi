require 'rails_helper'

RSpec.describe OffersController, :type => :feature do 

  feature "search offers api" do

      let(:offers){[{"title" => "title1", "payout" => "10" ,"thumbnail" => {"lowres" => "thumbnail1.png"}},
        {"title" => "title2", "payout" => "20" ,"thumbnail" => {"lowres" => "thumbnail2.png"}},
        {"title" => "title3", "payout" => "30" ,"thumbnail" => {"lowres" => "thumbnail3.png"}}]}
      let(:query_attributes){{"appid"=>157, "device_id"=>"2b6f0cc904d137be2e1730235f5664094b831186", "format"=>"json", "ip"=>"109.235.143.113", "locale"=>"de", "offer_types"=>112, "uid"=>"player1", "pub0"=>"campain1", "page"=>"1", "timestamp"=>1414835365}}

      scenario "visit root page should have this format" do
        visit "/"
        expect(page).to have_text("Fyber Offers Search")
        page.has_field?('uid', :with => 'Eneter User Id')
        page.has_field?('pub0', :with => 'Eneter Pub0')
        page.has_select?('page', :selected => 'Select Page')
        page.has_button?('commit', :text => 'Go!')
        page.has_button?('clear', :text => 'Clear')
      end

      scenario "call fyber api with invalid request" do
        allow_any_instance_of(Offer).to receive(:base_query_hash).and_return(query_attributes)
        visit "/"
        fill_in("offer_uid", :with => "player1")
        fill_in("offer_pub0", :with => "campaign1")
        select "1", :from => 'offer_page'
        click_button("Go!")
        expect(page).to have_text("An invalid hashkey for this appid was given as a parameter in the request.")
      end

      scenario "fill and submit the form with missing uid" do
        visit "/"
        fill_in("offer_pub0", :with => "campaign1")
        select "1", :from => 'offer_page'
        click_button("Go!")
        expect(page).to have_text("Uid can't be blank")
      end

      scenario "fill and submit the form with uid get no offers" do
        visit "/"
        fill_in("offer_uid", :with => "aaaa")
        fill_in("offer_pub0", :with => "campaign1")
        select "1", :from => 'offer_page'
        click_button("Go!")
        expect(page).to have_text("No offers")
      end

      scenario "fill and submit valid form and render offers" do
        allow_any_instance_of(Offer).to receive(:valid?).and_return(true)
        allow_any_instance_of(Offer).to receive(:search).and_return(true)
        allow_any_instance_of(Offer).to receive(:offers).and_return(offers)

        visit "/"
        fill_in("offer_uid", :with => "aaaa")
        fill_in("offer_pub0", :with => "campaign1")
        select "1", :from => 'offer_page'
        click_button("Go!")

        offers.each_with_index do |offer|
          expect(page).to have_content(offer["title"])
          expect(page).to have_content(offer["payout"])
          expect(page.has_xpath?(".//img[@src='#{offer['thumbnail']['lowres']}']")).to be(true) 
        end
      end

    end
  end
