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
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)
      @merchant_4 = create(:merchant)
      @merchant_5 = create(:merchant)
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_2)
      @item_3 = create(:item, merchant: @merchant_3)
      @item_4 = create(:item, merchant: @merchant_4)
      @item_5 = create(:item, merchant: @merchant_5)
      @invoice_1 = create(:invoice, merchant: @merchant_1)
      @invoice_2 = create(:invoice, merchant: @merchant_2)
      @invoice_3 = create(:invoice, merchant: @merchant_3)
      @invoice_4 = create(:invoice, merchant: @merchant_4)
      @invoice_5 = create(:invoice, merchant: @merchant_5)
      @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 10, unit_price: 10.00) # $100
      @invoice_item_2 = create(:invoice_item, invoice: @invoice_2, item: @item_2, quantity: 9, unit_price: 9.00) # $81
      @invoice_item_3 = create(:invoice_item, invoice: @invoice_3, item: @item_3, quantity: 8, unit_price: 8.00) # $64
      @invoice_item_4 = create(:invoice_item, invoice: @invoice_4, item: @item_4, quantity: 7, unit_price: 7.00) # $49
      @invoice_item_5 = create(:invoice_item, invoice: @invoice_5, item: @item_5, quantity: 6, unit_price: 6.00) # $36
      @transaction_1 = create(:transaction, invoice: @invoice_1, result: "success")
    end

    it '.top_profiteers' do
      expect(Merchant.top_profiteers(1).first).to eq(@merchant_1)
      expect(Merchant.top_profiteers(5)[0]).to eq(@merchant_1)
      expect(Merchant.top_profiteers(5)[1]).to eq(@merchant_2)
      expect(Merchant.top_profiteers(5)[2]).to eq(@merchant_3)
      expect(Merchant.top_profiteers(1).first.revenue).to eq(100.00)
    end

    it '.top_item_sellers' do
      expect(Merchant.top_item_sellers(1).first).to eq(@merchant_1)
      expect(Merchant.top_item_sellers(5)[0]).to eq(@merchant_1)
      expect(Merchant.top_item_sellers(5)[1]).to eq(@merchant_2)
      expect(Merchant.top_item_sellers(5)[2]).to eq(@merchant_3)
    end

    it '.total_revenue_by_date' do
      date = Date.today.strftime("%F")
      expect(Merchant.total_revenue_by_date(date)[0].total_revenue).to eq(330)
    end

    it '.total_revenue' do
      expect(Merchant.total_revenue(@merchant_1.id).revenue).to eq(100)
    end
  end

  describe 'Instance Methods' do
  end

end
