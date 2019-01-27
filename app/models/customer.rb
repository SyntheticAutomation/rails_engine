class Customer < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name
  has_many :invoices

  def self.favorite_merchant(id)
    joins(invoices: :transactions)
    .group(:id)
    .order("count(invoices.id) DESC")
    .where(transactions: {result: "success"}, id: id)
    .first
  end
end
