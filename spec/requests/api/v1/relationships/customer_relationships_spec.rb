require 'rails_helper'

describe 'Merchants API' do
  before(:each) do
    m_1 = create(:merchant)
    @c_1 = create(:customer)
    @item_1 = create(:item, merchant: m_1)
    @invoice_1 = create(:invoice, merchant: m_1, customer: @c_1, status: "failed")
    @invoice_2 = create(:invoice, merchant: m_1, customer: @c_1, status: "pending")
    @transaction_1 = create(:transaction, invoice: @invoice_1)
    @transaction_2 = create(:transaction, invoice: @invoice_1, result: "completely complete")
    @invoice_item_1 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 999)
    @invoice_item_2 = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 13)
  end

  it 'sends invoices specific to one customer' do

    get "/api/v1/customers/#{@c_1.id}/invoices"

    invoices = JSON.parse(response.body)
    expect(invoices["data"][0]["attributes"]["status"]).to eq("failed")
    expect(invoices["data"][1]["attributes"]["status"]).to eq("pending")
  end

  it 'sends transactions specific to one customer' do

    get "/api/v1/customers/#{@c_1.id}/transactions"

    transactions = JSON.parse(response.body)
    expect(transactions["data"][1]["attributes"]["result"]).to eq("completely complete")
  end
end
