class Api::V1::Items::MerchantController < ApplicationController

  def show
    render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
  end

end
