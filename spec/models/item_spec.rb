require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'Relationships' do
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should belong_to :merchant }
  end

  describe 'class methods' do
    it '.most_revenue' do
      i_1 = create(:item)
      i_2 = create(:item)
      i_3 = create(:item)
      i_4 = create(:item)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_3 = create(:invoice)
      invoice_4 = create(:invoice)
      invoice_item_1 = create(:invoice_item, item: i_1, invoice: invoice_1, unit_price: 10.00, quantity: 1)
      invoice_item_2 = create(:invoice_item, item: i_2, invoice: invoice_2, unit_price: 20.00, quantity: 2)
      invoice_item_3 = create(:invoice_item, item: i_3, invoice: invoice_3, unit_price: 30.00, quantity: 3)
      invoice_item_4 = create(:invoice_item, item: i_4, invoice: invoice_4, unit_price: 40.00, quantity: 4)

      expect(Item.most_revenue(4)[0]).to eq(i_4)
      expect(Item.most_revenue(4)[0].revenue).to eq(160.00)
    end
    it '.most_items' do
      i_1 = create(:item)
      i_2 = create(:item)
      i_3 = create(:item)
      i_4 = create(:item)
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      invoice_3 = create(:invoice)
      invoice_4 = create(:invoice)
      invoice_item_1 = create(:invoice_item, item: i_1, invoice: invoice_1, unit_price: 10.00, quantity: 1)
      invoice_item_2 = create(:invoice_item, item: i_2, invoice: invoice_2, unit_price: 20.00, quantity: 2)
      invoice_item_3 = create(:invoice_item, item: i_3, invoice: invoice_3, unit_price: 30.00, quantity: 3)
      invoice_item_4 = create(:invoice_item, item: i_4, invoice: invoice_4, unit_price: 40.00, quantity: 4)

      expect(Item.most_items(4)[0]).to eq(i_4)
    end
    it '.best_day' do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)
      item_1 = create(:item, merchant: merchant_1)
      invoice_1 = create(:invoice, customer: customer_1, merchant: merchant_1, created_at: 3.days.ago)
      invoice_2 = create(:invoice, customer: customer_1, merchant: merchant_1, created_at: 4.days.ago)
      invoice_3 = create(:invoice, customer: customer_1, merchant: merchant_1, created_at: 5.days.ago)
      invoice_4 = create(:invoice, customer: customer_1, merchant: merchant_1, created_at: 6.days.ago)
      invoice_item_1 = create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 3)
      invoice_item_2 = create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 4)
      invoice_item_3 = create(:invoice_item, invoice: invoice_3, item: item_1, quantity: 5)
      invoice_item_4 = create(:invoice_item, invoice: invoice_4, item: item_1, quantity: 90000)

      expect(Item.best_day(item_1.id).created_at.strftime("%F")).to eq(invoice_4.created_at.strftime("%F"))
    end
  end

  describe 'instance methods' do
  end

end
