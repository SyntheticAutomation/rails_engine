class ItemSoldSerializer
  include FastJsonapi::ObjectSerializer
  attributes :quantity_sold
end
