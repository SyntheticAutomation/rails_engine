class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :revenue do |a|
    (a.revenue / 100).to_s
  end
end
