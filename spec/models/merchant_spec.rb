require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'Class Methods' do
    it '.top_merchants_by_revenue' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant)
      merchant_5 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1, unit_price: 1)
      item_2 = create(:item, merchant: merchant_2, unit_price: 1)
      item_3 = create(:item, merchant: merchant_3, unit_price: 1)
      item_4 = create(:item, merchant: merchant_4, unit_price: 1)
      item_5 = create(:item, merchant: merchant_5, unit_price: 1)
      invoice_1 = create(:invoice)
      create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 100)#merchant_1 has sold $100 and should be second highest
      create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 1, unit_price: 70)
      create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 1, unit_price: 70) #merchant_2 has sold $140 gross revenue and should be at the top
      create(:invoice_item, invoice: invoice_1, item: item_3, quantity: 1, unit_price: 90) #merchant_3 has sold $90 and should be third highest
      create(:invoice_item, invoice: invoice_1, item: item_4, quantity: 1, unit_price: 60)
      create(:invoice_item, invoice: invoice_1, item: item_5, quantity: 1, unit_price: 80)

      expect(Merchant.top_profiteers(1)).to eq(merchant_2)
      expect(Merchant.top_profiteers(5)[0]).to eq(merchant_2)
      expect(Merchant.top_profiteers(5)[1]).to eq(merchant_1)
      expect(Merchant.top_profiteers(5)[2]).to eq(merchant_3)

    end
  end

  describe 'Instance Methods' do
  end

end
