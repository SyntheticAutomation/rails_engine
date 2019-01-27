class MerchantTotalRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :total_revenue do |a|
    (a.total_revenue / 100).to_s
  end
end
