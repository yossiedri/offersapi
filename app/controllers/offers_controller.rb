class OffersController < ApplicationController

  before_action :set_offer 
  include OffersHelper

  def search

    if params[:offer]
      if @offer.valid? && @offer.search
        @offers = @offer.offers
      else
        redirect_to search_path unless @offer.errors.any?
      end 
    end 

  end

  private
  def set_offer
    @offer = offer_params.nil? ? Offer.new : Offer.new(offer_params.delete_if{|k, v| v.blank?})
  end

  def offer_params
    params[:offer] ? params[:offer].permit(:uid , :pub0 , :page) : nil
  end
end

