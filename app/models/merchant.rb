class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items

  def self.top_profiteers(limit = 0)
    joins(invoices: {:items => :invoice_items} )
    .group("merchants.id")
    .order("revenue DESC")
    .select("merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .limit(limit)
  end

  def self.top_item_sellers(limit = 0)
    joins(invoices: {:items => :invoice_items} )
    .group("merchants.id")
    .order("items_sold DESC")
    .select("merchants.*, sum(invoice_items.quantity) as items_sold")
    .limit(limit)
  end
end
