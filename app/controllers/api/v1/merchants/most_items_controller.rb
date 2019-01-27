class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    render json: MerchantMostItemsSerializer.new(Merchant.top_item_sellers(params[:quantity]))
  end
end
