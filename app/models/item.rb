class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items


  def self.most_revenue(limit = 0)
      joins(invoices: :invoice_items)
      .group(:id)
      .order("revenue DESC")
      .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
      .limit(limit)
  end

  def self.most_items(limit = 0)
    joins(invoices: :invoice_items)
    .group(:id)
    .order("quantity_sold DESC")
    .select("items.*, sum(invoice_items.quantity) as quantity_sold")
    .limit(limit)
  end


end
