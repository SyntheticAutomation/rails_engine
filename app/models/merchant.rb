class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items

  def self.total_revenue(id)
    joins(:invoices, invoices: [:invoice_items, :transactions])
    .group(:id)
    .order("revenue DESC")
    .select("sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .where(id: id, transactions: {result: 'success'})
    .first
  end

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

  def self.total_revenue_by_date(date)
    parsed_date = DateTime.parse(date)
    joins(invoices: {:items => :invoice_items} )
    .select("sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue")
    .where(invoices: { created_at: parsed_date..parsed_date.at_end_of_day })
  end

  def self.individual_revenue_by_date(id, date)
    parsed_date = DateTime.parse(date)
    joins(:invoices, invoices: [:invoice_items, :transactions])
    .group(:id)
    .select("sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .where(id: id, transactions: {result: "success"}, invoices: { created_at: parsed_date..parsed_date.at_end_of_day })
  end

  def self.favorite_customer(id)
    Customer.joins(:invoices, invoices: :transactions)
    .select("customers.*, count(transactions) as tx_count")
    .order("tx_count DESC")
    .group(:id)
    .where(invoices: {merchant_id: id}, transactions: {result: 'success'})
  end
end
