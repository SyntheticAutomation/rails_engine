class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: MerchantTotalRevenueSerializer.new(Merchant.total_revenue_by_date(params[:date]))
  end

  def show
    render json: MerchantRevenueSerializer.new(Merchant.total_revenue_earned(params[:id])) unless params[:date]
    render json: MerchantRevenueSerializer.new(Merchant.individual_revenue_by_date(params[:id], params[:date])) if params[:date]

  end
end
