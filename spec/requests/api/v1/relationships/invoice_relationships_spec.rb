require 'rails_helper'

describe 'Invoices API' do
  before(:each) do
    m_1 = create(:merchant, name: "Goldstein's Gummy Bears")
    c_1 = create(:customer, first_name: "Nicole")
    @item_1 = create(:item, description: "Grilled Cedar Plank Salmon on a Bed of Fettucini Alfredo")
    @invoice_1 = create(:invoice, merchant: m_1, customer: c_1)
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: "completely complete")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 999)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 13)

  end
  it 'sends transactions specific to one invoice' do
    get "/api/v1/invoices/#{@invoice_1.id}/transactions"

    transactions = JSON.parse(response.body)
    expect(transactions["data"][1]["attributes"]["result"]).to eq("completely complete")
  end

  it 'sends invoice_items specific to one invoice' do
    get "/api/v1/invoices/#{@invoice_1.id}/invoice_items"

    i_i = JSON.parse(response.body)
    expect(i_i["data"][0]["attributes"]["quantity"]).to eq(999)
    expect(i_i["data"][1]["attributes"]["quantity"]).to eq(13)
  end

  it 'sends items specific to one invoice' do
    get "/api/v1/invoices/#{@invoice_1.id}/items"
    items = JSON.parse(response.body)
    expect(items["data"][0]["attributes"]["description"]).to eq("Grilled Cedar Plank Salmon on a Bed of Fettucini Alfredo")
  end

  it 'sends the customer specific to one invoice' do
    get "/api/v1/invoices/#{@invoice_1.id}/customer"
    customer = JSON.parse(response.body)
    expect(customer["data"]["attributes"]["first_name"]).to eq("Nicole")
  end

  it 'sends the merchant specific to one invoice' do
    get "/api/v1/invoices/#{@invoice_1.id}/merchant"
    merchant = JSON.parse(response.body)
    expect(merchant["data"]["attributes"]["name"]).to eq("Goldstein's Gummy Bears")
  end
end
