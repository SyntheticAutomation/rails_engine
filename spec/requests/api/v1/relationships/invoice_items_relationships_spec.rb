require 'rails_helper'

describe 'InvoiceItems API' do
  before(:each) do
    m_1 = create(:merchant, name: "Goldstein's Gummy Bears")
    c_1 = create(:customer, first_name: "Nicole")
    @item_1 = create(:item, description: "Fluffy omelette made with farm fresh eggs, leafy spinach, and crisp applewood smoked bacon.")
    @invoice_1 = create(:invoice, merchant: m_1, customer: c_1, status: "delayed")
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: "completely complete")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 999)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 13)
  end

  it 'sends the invoice specific to one invoice_item' do
    get "/api/v1/invoice_items/#{@invoice_item_1.id}/invoice"
    invoice = JSON.parse(response.body)
    expect(invoice["data"]["attributes"]["status"]).to eq("delayed")
  end

  it 'sends the item specific to one invoice_item' do
    get "/api/v1/invoice_items/#{@invoice_item_1.id}/item"
    item = JSON.parse(response.body)
    expect(item["data"]["attributes"]["description"]).to eq("Fluffy omelette made with farm fresh eggs, leafy spinach, and crisp applewood smoked bacon.")
  end
end
