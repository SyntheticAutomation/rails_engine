class ItemRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :unit_price, :merchant_id
  attributes :revenue do |a|
    a.revenue / 100
  end
end
