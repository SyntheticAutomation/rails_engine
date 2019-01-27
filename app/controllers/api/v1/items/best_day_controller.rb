class Api::V1::Items::BestDayController < ApplicationController

  def index
    render json: ItemBestDaySerializer.new(Item.best_day(params[:id]))
  end

end
