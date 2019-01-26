require 'rails_helper'

describe 'Items API' do
  before(:each) do
    m_1 = create(:merchant, name: "Rolex")
    c_1 = create(:customer, first_name: "Smitty")
    @item_1 = create(:item, merchant: m_1)
    @invoice_1 = create(:invoice, merchant: m_1, customer: c_1)
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: "completely complete")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 999)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 13)
  end

  it 'sends the invoice_items specific to one item' do
    get "/api/v1/items/#{@item_1.id}/invoice_items"
    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"][0]["attributes"]["quantity"]).to eq(999)
    expect(invoice_items["data"][1]["attributes"]["quantity"]).to eq(13)
  end

  it 'sends the merchant specific to one item' do
    get "/api/v1/items/#{@item_1.id}/merchant"
    merchant = JSON.parse(response.body)
    expect(merchant["data"]["attributes"]["name"]).to eq("Rolex")
  end
end
