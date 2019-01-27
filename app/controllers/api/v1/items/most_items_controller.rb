class Api::V1::Items::MostItemsController < ApplicationController

  def index
    render json: ItemSoldSerializer.new(Item.most_items(params[:quantity]))
  end

end
