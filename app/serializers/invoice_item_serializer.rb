class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :invoice
  belongs_to :item
  attributes :id, :invoice_id, :item_id, :quantity, :unit_price
end
