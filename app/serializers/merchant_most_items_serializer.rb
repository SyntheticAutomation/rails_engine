class MerchantMostItemsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :items_sold
end
